import 'dart:convert';
import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:miumusic/controllers/musicController.dart';
import 'package:miumusic/controllers/searchController.dart';
import 'package:miumusic/home/playlists/pages/playlist.dart';

var music = new Music();

class userPlaylist extends StatefulWidget {
  final id;
  userPlaylist({Key key, this.id}) : super(key: key);

  @override
  _userPlaylistState createState() => _userPlaylistState();
}

class _userPlaylistState extends State<userPlaylist> {
  var playlists;
  var search = Search();

  void initState() {
    playlists = music.playlistsUser(widget.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text("Tus Playlists"),
        ),
        body: FutureBuilder(
            future: playlists,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map datos = jsonDecode(snapshot.data);

                if (datos['music'] == "vacio") {
                  return Center(child: Text("No hay Playlists"));
                }
                List lista = datos['music'];

                return Container(
                  height: size.height,
                  child: FloatingSearchBar.builder(
                    padding: EdgeInsets.all(12.0),
                    pinned: true,
                    itemCount: lista.length == 0 ? 1 : lista.length,
                    itemBuilder: (BuildContext context, int index) {
                      return playlist(
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
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }

  Future<String> getFind(value) async {
    var find = await search.getFinder(value, "null", widget.id);
    return find;
  }
}
