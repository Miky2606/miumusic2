import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:miumusic/controllers/social.dart';
import 'package:miumusic/controllers/userController.dart';
import 'package:miumusic/home/pages/local.dart';
import 'package:miumusic/home/pages/online.dart';
import 'package:miumusic/home/pages/search.dart';
import 'package:miumusic/home/playlists/pages/crearPlaylist.dart';
import 'package:miumusic/home/playlists/pages/userPlaylist.dart';
import 'package:miumusic/home/userInfo/user.dart';
import 'package:url_launcher/url_launcher.dart';

import 'loading/loading.dart';
import 'login/login.dart';

var userData = new User();
var social = new Social();

class scaffold extends StatefulWidget {
  final token;
  scaffold({Key key, this.token}) : super(key: key);

  @override
  _scaffoldState createState() => _scaffoldState();
}

class _scaffoldState extends State<scaffold> {
  var datos;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: userData.getToken(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return loading();
          }

          if (snapshot.data == "null") {
            return Scaffold(body: login());
          } else {
            return homeScaffold();
          }
        });
  }
}

class homeScaffold extends StatefulWidget {
  homeScaffold({Key key}) : super(key: key);

  @override
  _homeScaffoldState createState() => _homeScaffoldState();
}

int _currentIndex = 0;

class _homeScaffoldState extends State<homeScaffold> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: userData.datosUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map datosUser = json.decode(snapshot.data);

            if (datosUser['user'].length == 0 ||
                datosUser['token'] == "expired") {
              userData.logout(context);
            } else {
              List datos = datosUser["user"];
              var tabs = [
                online(),
                local(id: datos[0]['id']),
                search(id: datos[0]['id'])
              ];

              return Scaffold(
                drawer: Drawer(
                    child: ListView(children: [
                  DrawerHeader(
                      child: Center(child: Text("${datos[0]['username']} ")),
                      decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12)))),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: InkWell(
                      child: Text("Crear Playlist"),
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) =>
                                crearPlaylist(id: datos[0]['id'])));
                      },
                    )),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: InkWell(
                      child: Text("Mis Playlist"),
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) =>
                                userPlaylist(id: datos[0]['id'])));
                      },
                    )),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: () async {
                        userData.logout(context);
                      },
                      child: Text("Logout"),
                      color: Colors.greenAccent,
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(23),
                      child: FutureBuilder(
                          future: social.findSocial,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }

                            Map redes = jsonDecode(snapshot.data);
                            List tipoRedes = redes['redes'];

                            return Container(
                              height: size.height * .3,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: tipoRedes.length,
                                  itemBuilder: (context, index) {
                                    print(tipoRedes[index]);
                                    return Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: InkWell(
                                          child: tipoRedes[index]['red'] ==
                                                  "instagram"
                                              ? Image.asset(
                                                  "assets/pictures/instagram.png",
                                                  width: size.width * .1)
                                              : Image.asset(
                                                  "assets/pictures/facebook.png",
                                                  width: size.width * .1),
                                          onTap: () async {
                                            social.openRutas(
                                                tipoRedes[index]['ruta']);
                                          }),
                                    );
                                  }),
                            );
                          }))
                ])),
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(size.height * .1),
                  child: AppBar(
                    title: Center(
                      child: Padding(
                        padding: EdgeInsets.all(1.0),
                        child: Image.asset(
                          "assets/icon/icon.png",
                          width: size.width * .2,
                          height: size.height * .09,
                        ),
                      ),
                    ),
                    actions: [
                      IconButton(
                          icon: Icon(
                            Icons.account_circle,
                            size: 36,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => user(
                                    id: datos[0]['id'],
                                    email: datos[0]['email'],
                                    name: datos[0]['username'],
                                    fecha: datos[0]['fecha'])));
                          }),
                    ],
                  ),
                ),
                bottomNavigationBar: CurvedNavigationBar(
                    color: Colors.greenAccent[200],
                    backgroundColor: Colors.cyan,
                    buttonBackgroundColor: Colors.cyanAccent.withOpacity(.5),
                    onTap: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    items: [
                      Icon(Icons.home, color: Colors.white, size: 35),
                      Icon(Icons.library_music, color: Colors.white, size: 35),
                      Icon(Icons.music_note, color: Colors.white, size: 35),
                    ]),
                body: tabs[_currentIndex],
              );
            }
          } else {
            return loading();
          }
        });
  }
}
