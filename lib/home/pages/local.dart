import 'dart:convert';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miumusic/controllers/musicController.dart';

import 'package:miumusic/home/playlists/pages/playlist.dart';
import 'package:miumusic/home/playlists/pages/playlistPublicAll.dart';
import 'package:miumusic/home/playlists/pages/userPlaylist.dart';

var musicController = new Music();

class local extends StatefulWidget {
  final id;
  local({Key key, this.id}) : super(key: key);

  @override
  _localState createState() => _localState();
}

class _localState extends State<local> {
  var playlistUser;
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Center(
                    child: Text("Playlists Publicas",
                        style: TextStyle(color: Colors.black, fontSize: 22))),
                Spacer(),
                IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) =>
                              playlistPublicAll(id: widget.id)));
                    })
              ],
            ),
          ),
          Divider(),
          FutureBuilder(
              future: musicController.playlists,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map datos = jsonDecode(snapshot.data);
                  if (datos['music'] == "vacio") {
                    return Center(child: Text("No hay Playlists"));
                  }

                  List playlists = datos['music'];

                  return Container(
                    height: 200.0,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: playlists.length,
                        itemBuilder: (context, index) {
                          return playlist(
                              name: playlists[index]['name'],
                              id: playlists[index]['id'],
                              id_user: playlists[index]['id_user'],
                              currentUser: widget.id);
                        }),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Row(
              children: [
                Text("Tus Playlists",
                    style: TextStyle(color: Colors.black, fontSize: 22)),
                Spacer(),
                IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      print(widget.id);
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => userPlaylist(id: widget.id)));
                    })
              ],
            )),
          ),
          FutureBuilder(
              future: musicController.playlistsUser(widget.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map datos = jsonDecode(snapshot.data);
                  if (datos['music'] == "vacio") {
                    return Center(child: Text("No hay Playlists"));
                  }

                  List playlists = datos['music'];

                  return Container(
                    height: 200.0,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: playlists.length,
                        itemBuilder: (context, index) {
                          return playlist(
                              name: playlists[index]['name'],
                              id: playlists[index]['id'],
                              id_user: playlists[index]['id_user'],
                              currentUser: widget.id,
                              type: playlists[index]['type']);
                        }),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ],
      )),
    );
  }
}
