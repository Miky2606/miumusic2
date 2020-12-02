import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:miumusic/controllers/notification.dart';
import 'package:miumusic/controllers/userController.dart';
import 'package:miumusic/home/playlists/pages/playlist.dart';
import 'package:miumusic/home/userInfo/userPlaylistSave.dart';

var notification = new Notificacion();

class user extends StatefulWidget {
  final id;
  final email;
  final name;
  final fecha;

  user({Key key, this.id, this.email, this.fecha, this.name}) : super(key: key);

  @override
  _userState createState() => _userState();
}

class _userState extends State<user> {
  int _index;
  @override
  void initState() {
    setState(() {
      _index = 0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var tab = [
      info(
          name: widget.name,
          fecha: widget.fecha,
          email: widget.email,
          id: widget.id),
      playlistsUser(id: widget.id)
    ];
    return Scaffold(
      appBar: AppBar(
          title: Text("${widget.name}"),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ))),
      body: tab[_index],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.black,
          currentIndex: _index,
          onTap: (index) {
            setState(() {
              _index = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.account_box), title: Text("User")),
            BottomNavigationBarItem(
                icon: Icon(Icons.library_music),
                title: Text('Playlist Guardadas'))
          ]),
    );
  }
}

class info extends StatelessWidget {
  final name;
  final fecha;
  final email;
  final id;
  const info({Key key, this.name, this.email, this.id, this.fecha})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = new User();

    final _controller = TextEditingController();
    final size = MediaQuery.of(context).size;
    return Container(
        color: Colors.greenAccent,
        child: Stack(children: [
          Container(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 2),
                    blurRadius: 3,
                    spreadRadius: 3,
                  )
                ],
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(22),
                    bottomLeft: Radius.circular(22))),
            height: size.height * .32,
          ),
          ListView(
            children: [
              Center(
                child: Image.asset(
                  "assets/icon/icon.png",
                ),
              ),
              Center(
                child: Text(
                  "${this.name}",
                  style: TextStyle(fontSize: 34),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 14.2,
                    color: Colors.greenAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Center(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.mail),
                            ),
                            Text(
                              "${this.email}",
                              style: TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 14.2,
                    color: Colors.greenAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: size.width * .7,
                            child: TextField(
                              controller: _controller,
                              obscureText: true,
                              decoration: InputDecoration(hintText: "Password"),
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () {
                                if (_controller.text == "") {
                                  var text =
                                      "El password no debe estar en blanco";
                                  notification.flushbarSnackbarError(
                                      context, text);
                                } else {
                                  if (_controller.text.length < 5) {
                                    var text =
                                        "El password debe tener mas de 5 caracteres";
                                    notification.flushbarSnackbarError(
                                        context, text);
                                  } else {
                                    var userPassword = user.changePassword(
                                        _controller.text, this.id, context);
                                  }
                                }
                              })
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ]));
  }
}
