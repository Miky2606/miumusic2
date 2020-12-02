import 'dart:convert';

import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:miumusic/controllers/musicController.dart';
import 'package:miumusic/controllers/searchController.dart';
import 'package:miumusic/home/playlists/pages/playlist.dart';

var musicController = Music();

class playlistPublicAll extends StatefulWidget {
  final id;
  playlistPublicAll({Key key, this.id}) : super(key: key);

  @override
  _playlistPublicAllState createState() => _playlistPublicAllState();
}

class _playlistPublicAllState extends State<playlistPublicAll> {
  var playlists;
  int page = 0;
  bool finding = false;
  final search = new Search();
  bool cargar = false;

  @override
  void initState() {
    playlists = musicController.playlists;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text("Publicas"),
        ),
        body: FutureBuilder(
            future: playlists,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map datos = jsonDecode(snapshot.data);
                List lista = datos['music'];

                if (datos['music'] == []) {
                  setState(() {
                    cargar = true;
                  });
                }

                if (datos['music'] == "vacio") {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 38.0),
                    child: Text("No hay Playlists"),
                  );
                }
                return ListView(
                  children: [
                    Container(
                      height: size.height * .8,
                      child: FloatingSearchBar.builder(
                        padding: EdgeInsets.all(12.0),
                        pinned: true,
                        itemCount: lista.length,
                        itemBuilder: (BuildContext context, int index) {
                          return cargar == true
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 38.0),
                                  child: Text("No hay Playlists"),
                                )
                              : playlist(
                                  name: lista[index]['name'],
                                  id: lista[index]['id'],
                                  id_user: lista[index]['id_user'],
                                  currentUser: widget.id);
                        },
                        onChanged: (value) {
                          setState(() {
                            playlists = getFind(value);
                          });
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }

  Future<String> getFind(value) async {
    var find = await search.getFinder(value, "public", "null");

    return find;
  }
}
