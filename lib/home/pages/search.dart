import 'dart:convert';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:floating_search_bar/floating_search_bar.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:miumusic/controllers/musicController.dart';

import 'package:miumusic/controllers/reproductor.dart';
import 'package:miumusic/controllers/searchController.dart';
import 'package:miumusic/home/playlists/pages/adicionarPlaylist.dart';

import 'package:dio/dio.dart';

var reproducir = new Reproductor();
var musicController = Music();

class search extends StatefulWidget {
  final id;
  search({Key key, this.id}) : super(key: key);

  @override
  _searchState createState() => _searchState();
}

class _searchState extends State<search> {
  final search = new Search();
  var datos;

  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId("0");

  @override
  void initState() {
    datos = musicController.getMusic();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: datos,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              Map datosMusic = jsonDecode(snapshot.data);
              List music = datosMusic['search'];

              return Padding(
                padding: const EdgeInsets.all(1.0),
                child: Container(
                  child: FloatingSearchBar.builder(
                    padding: EdgeInsets.all(12.0),
                    pinned: true,
                    itemCount: music.length,
                    itemBuilder: (BuildContext context, int index) {
                      String nombre = '${music[index]['ruta']}';
                      var ruta = music[index]['ruta'];
                      var name = music[index]['name'];
                      var extname = nombre.split(".");
                      return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Card(
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      child:
                                          Image.asset("assets/icon/icon.png"),
                                    ),
                                    Spacer(),
                                    SizedBox(
                                        width: 120,
                                        child: Text(
                                          "${music[index]["name"]}",
                                          style: TextStyle(fontSize: 13),
                                        )),
                                    Spacer(),
                                    InkWell(
                                        onTap: () {
                                          var autor = music[index]['autor'];
                                          var album = music[index]['album'];
                                          reproducir.reproducirSolo(
                                              ruta, name, autor, album);
                                        },
                                        child: Icon(Icons.play_arrow)),
                                    IconButton(
                                        icon: Icon(Icons.cloud_download),
                                        onPressed: () async {
                                          musicController.downloadMusic(
                                              context, ruta, name, extname);
                                        }),
                                    IconButton(
                                        icon: Icon(
                                          Icons.playlist_add,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      adicionarPlaylist(
                                                          music_id: music[index]
                                                              ['id'],
                                                          id: widget.id)));
                                        })
                                  ],
                                ),
                              ),
                            ),
                          ));
                    },
                    onChanged: (String value) async {
                      var storage = FlutterSecureStorage();
                      var token = await storage.read(key: "token");
                      setState(() {
                        datos = getSearchMusic(value, token);
                      });
                    },
                    onTap: () {},
                    decoration: InputDecoration.collapsed(
                      hintText: "Search...",
                    ),
                    trailing: Text("Encontrados: ${music.length}"),
                  ),
                ),
              );
            }));
  }

  Future<String> getSearchMusic(value, token) async {
    var find = await search.getMusic(token, value);
    return find;
  }
}
