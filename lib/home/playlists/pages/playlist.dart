import 'dart:convert';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:miumusic/home/pages/local.dart';
import 'package:miumusic/home/playlists/display/DisplayMusic.dart';

class playlist extends StatefulWidget {
  final name;
  final id;
  final id_user;
  final currentUser;
  final type;

  const playlist(
      {Key key, this.name, this.id, this.id_user, this.currentUser, this.type})
      : super(key: key);

  @override
  _playlistState createState() => _playlistState();
}

class _playlistState extends State<playlist> {
  bool add;
  var playlist_save;

  playlistGet() async {
    var response =
        await musicController.getPlaylistSave(widget.id, widget.currentUser);
    setState(() {
      add = response;
    });
  }

  @override
  void initState() {
    setState(() {
      playlist_save = playlistGet();
    });

    super.initState();
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white.withOpacity(.5),
          boxShadow: [
            BoxShadow(color: Colors.cyan.withOpacity(.5), blurRadius: 6.0)
          ],
        ),
        height: 220,
        width: 160,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Text("${widget.name} ",
                      style: TextStyle(color: Colors.black))),
            ),
            InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DisplayMusic(
                          id: widget.id,
                          id_user: widget.id_user,
                          currentUser: widget.currentUser,
                          name: widget.name,
                          type: widget.type)));
                },
                child: FlareActor(
                  "assets/animation/music.flr",
                  animation: "Hover",
                )),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      children: [
                        add == true
                            ? IconButton(
                                icon: Icon(Icons.bookmark,
                                    size: 18, color: Colors.blue),
                                onPressed: () async {
                                  var response =
                                      await musicController.deletePlaylistFav(
                                          widget.id_user, widget.id, context);

                                  if (response == true) {
                                    setState(() {
                                      add = false;
                                    });
                                  }
                                })
                            : IconButton(
                                icon: Icon(Icons.bookmark_border,
                                    size: 18, color: Colors.lightBlueAccent),
                                onPressed: () async {
                                  var response =
                                      await musicController.addPlaylistFav(
                                          widget.id_user,
                                          widget.id,
                                          widget.name,
                                          context);

                                  if (response == true) {
                                    setState(() {
                                      add = true;
                                    });
                                  }
                                })
                      ],
                    )))
          ],
        ),
      ),
    );
  }
}
