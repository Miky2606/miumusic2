import 'dart:convert';

import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:flare_flutter/flare_actor.dart';

import 'package:flutter/material.dart';

import 'package:miumusic/controllers/reproductor.dart';
import 'package:miumusic/home/loading/loading.dart';
import 'package:miumusic/home/playlists/display/musicNo%20User.dart';
import 'package:miumusic/home/playlists/display/userMusic.dart';
import 'package:miumusic/home/playlists/display/vacioPlaylist.dart';

var reproducir = new Reproductor();

class DisplayMusic extends StatefulWidget {
  final id;
  final id_user;
  final currentUser;
  final name;
  final type;

  DisplayMusic(
      {Key key, this.id, this.id_user, this.name, this.currentUser, this.type})
      : super(key: key);

  @override
  _DisplayMusicState createState() => _DisplayMusicState();
}

class _DisplayMusicState extends State<DisplayMusic> {
  bool play;
  bool playlist;
  String audio;
  String nulo;
  bool type;
  var music;
  var musicPlaying;
  List<Audio> musicPlaylist;
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId("0");

  @override
  void initState() {
    setState(() {
      musicPlaylist = [];
      playlist = false;
      play = false;
      music = reproducir.getDatos(widget.id);
      audio = "";
      nulo = "";
      if (widget.type == "privado") {
        type = false;
      } else {
        type = true;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = GlobalKey<ScaffoldState>();
    final size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: music,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return loading();
          } else {
            Map data = json.decode(snapshot.data);

            if (data['music'] == "no hay" || nulo == "no hay") {
              return vacioPlaylist(
                  id: widget.id,
                  name: widget.name,
                  id_user: widget.id_user,
                  currentUser: widget.currentUser,
                  type: widget.type);
            } else {
              List datos = data['datos'];

              return Scaffold(
                key: scaffold,
                appBar: AppBar(
                  title: Text("${widget.name}"),
                  actions: [
                    widget.id_user == widget.currentUser
                        ? Row(
                            children: [
                              Icon(Icons.lock),
                              SizedBox(
                                  child: Switch(
                                value: type,
                                onChanged: (value) async {
                                  var typeChange;

                                  if (value == true) {
                                    typeChange = "public";
                                  } else {
                                    typeChange = "privado";
                                  }
                                  var response = await reproducir.updateMusic(
                                      widget.id, typeChange, context);

                                  if (response == true) {
                                    setState(() {
                                      type = value;
                                    });
                                  }
                                },
                                activeColor: Colors.red,
                              )),
                              Icon(Icons.lock_open),
                              IconButton(
                                  icon: Icon(Icons.delete), onPressed: null)
                            ],
                          )
                        : SizedBox(),
                  ],
                ),
                body: Container(
                  height: size.height,
                  child: Stack(children: [
                    FlareActor("assets/animation/auras.flr", animation: "Aura"),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            Container(
                              width: size.width,
                              color: Colors.red,
                            ),
                            Image.asset(
                              "assets/icon/icon.png",
                              height: size.height * .15,
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Row(
                                children: [
                                  Spacer(),
                                  IconButton(
                                      alignment: Alignment.topCenter,
                                      icon: Icon(Icons.skip_previous),
                                      color: Colors.pink,
                                      onPressed: () {
                                        audioPlayer.previous();
                                      }),
                                  audioPlayer.builderIsPlaying(
                                      builder: (context, playing) {
                                    if (playing == false) {
                                      return IconButton(
                                          alignment: Alignment.topCenter,
                                          icon: Icon(Icons.play_arrow),
                                          iconSize: 35,
                                          color: Colors.pink,
                                          onPressed: () {
                                            audioPlayer.playOrPause();
                                          });
                                    } else {
                                      return IconButton(
                                          alignment: Alignment.topCenter,
                                          icon: Icon(Icons.pause),
                                          iconSize: 35,
                                          color: Colors.pink,
                                          onPressed: () {
                                            audioPlayer.playOrPause();
                                          });
                                    }
                                  }),
                                  IconButton(
                                      alignment: Alignment.topCenter,
                                      icon: Icon(Icons.skip_next),
                                      color: Colors.pink,
                                      onPressed: () {
                                        audioPlayer.next();
                                      }),
                                  Spacer()
                                ],
                              ),
                            ),
                            audioPlayer.builderRealtimePlayingInfos(
                                builder: (context, infos) {
                              if (infos != null) {
                                return Slider(
                                    max: infos.duration.inSeconds.toDouble(),
                                    value: infos.currentPosition.inSeconds
                                        .toDouble(),
                                    onChanged: (double value) {
                                      audioPlayer.seek(
                                          Duration(seconds: value.toInt()));
                                    },
                                    activeColor: Colors.greenAccent);
                              }

                              return Slider(max: 12, value: 0, onChanged: null);
                            }),
                            RaisedButton(
                                onPressed: () {
                                  setState(() {
                                    musicPlaylist =
                                        reproducir.addMusicPlaylisrt(datos);
                                    playlist = true;
                                  });
                                  reproducir.reproducirPlaylist(musicPlaylist);
                                },
                                child: Text("Reproducir Playlist")),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.4),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(22),
                                topRight: Radius.circular(22))),
                        height: size.height * .48,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: ListView.builder(
                                  itemCount: datos.length,
                                  itemBuilder: (context, index) {
                                    var item = datos[index][0]['name'];
                                    //Delete Music CurrentUser
                                    if (widget.id_user == widget.currentUser) {
                                      return userMusic(
                                        id: widget.id_user,
                                        id_playlist: widget.id,
                                        item: item,
                                        datos: datos,
                                        index: index,
                                        playlist: playlist,
                                      );
                                    } else {
                                      return musicNoUser(
                                        id: widget.id_user,
                                        item: item,
                                        datos: datos,
                                        index: index,
                                        playlist: playlist,
                                      );
                                    }
                                    //User doesn't delete music
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              );
            }
          }
        });
  }
}
