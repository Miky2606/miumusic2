import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:miumusic/controllers/musicController.dart';
import 'package:miumusic/home/playlists/pages/playlist.dart';

var musicController = new Music();

class playlistsUser extends StatefulWidget {
  final id;
  const playlistsUser({Key key, this.id}) : super(key: key);

  @override
  _playlistsUserState createState() => _playlistsUserState();
}

class _playlistsUserState extends State<playlistsUser> {
  var playlists_fav;

  initState() {
    setState(() {
      playlists_fav = musicController.getPlaylistSave(null, widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: playlists_fav,
        builder: (context, snapshot) {
          print(snapshot.data);
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == "vacio") {
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(22),
                      bottomLeft: Radius.circular(22))),
              height: size.height,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                        child: Text(
                      "No hay Playlist Guardadas",
                      style: TextStyle(fontSize: 22),
                    )),
                  ),
                  Center(
                    child: Image.asset("assets/pictures/escuchando.png"),
                  )
                ],
              ),
            );
          } else {
            List playlists_save = snapshot.data;
            return Container(
              height: size.height,
              child: ListView(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text("Playlists Guardadas",
                          style: TextStyle(fontSize: 23))),
                ),
                Container(
                  height: size.height,
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: List.generate(playlists_save.length, (index) {
                      return playlist(
                          id: playlists_save[index]['id_playlist'],
                          id_user: widget.id,
                          currentUser: widget.id,
                          name: playlists_save[index]['name']);
                    }),
                  ),
                ),
              ]),
            );
          }
        });
  }
}
