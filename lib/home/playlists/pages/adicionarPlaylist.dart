import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:miumusic/home/playlists/pages/playlist.dart';

class adicionarPlaylist extends StatefulWidget {
  final id;
  final music_id;
  adicionarPlaylist({Key key, this.id, this.music_id}) : super(key: key);

  @override
  _adicionarPlaylistState createState() => _adicionarPlaylistState();
}

class _adicionarPlaylistState extends State<adicionarPlaylist> {
  Future<String> get playlistsUser async {
    var response =
        await http.get("http://www.musicapi.online/playlistUser/${widget.id}");

    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
          future: playlistsUser,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map datos = jsonDecode(snapshot.data);
              if (datos['music'] == "vacio") {
                return Center(child: Text("No hay Playlists"));
              }

              List playlists = datos['music'];

              return Container(
                height: size.height * 3,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: playlists.length,
                    itemBuilder: (context, index) {
                      return Column(children: [
                        IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () async {
                              var response = await http.post(
                                  "http://www.musicapi.online/addMusicPlaylist/",
                                  body: {
                                    "id_playlist": "${playlists[index]['id']}",
                                    "id_song": "${widget.music_id}"
                                  });
                              Map message = jsonDecode(response.body);
                              if (message['playlist'] == "add") {
                                final snackbar = SnackBar(
                                    content: Text("adicionado"),
                                    duration: Duration(seconds: 1));
                                Scaffold.of(context).showSnackBar(snackbar);
                              } else {
                                final snackbar = SnackBar(
                                    content: Text("Ya existe"),
                                    duration: Duration(seconds: 1));
                                Scaffold.of(context).showSnackBar(snackbar);
                              }
                            }),
                        playlist(
                            name: playlists[index]['name'],
                            id: playlists[index]['id'],
                            id_user: playlists[index]['id_user'],
                            currentUser: widget.id),
                      ]);
                    }),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
