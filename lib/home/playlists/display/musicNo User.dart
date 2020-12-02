import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miumusic/controllers/musicController.dart';
import 'package:miumusic/controllers/reproductor.dart';
import 'package:miumusic/home/playlists/pages/adicionarPlaylist.dart';

var reproducir = new Reproductor();
var musicController = new Music();

class musicNoUser extends StatefulWidget {
  final datos;
  final item;
  final id;
  final index;

  final playlist;
  musicNoUser(
      {Key key, this.item, this.datos, this.id, this.index, this.playlist})
      : super(key: key);

  @override
  _musicNoUserState createState() => _musicNoUserState();
}

class _musicNoUserState extends State<musicNoUser> {
  @override
  Widget build(BuildContext context) {
    var ruta = widget.datos[widget.index][0]['ruta'];
    var name = widget.datos[widget.index][0]['name'];
    var extname = ruta.split(".");
    AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId("0");
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          if (widget.playlist == false) {
            var autor = widget.datos[widget.index][0]['autor'];
            var album = widget.datos[widget.index][0]['album'];

            reproducir.reproducirSolo(ruta, name, autor, album);
          } else {
            audioPlayer.playlistPlayAtIndex(widget.index);
          }
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                audioPlayer.builderCurrent(builder: (context, current) {
                  if (current == null) {
                    return SizedBox();
                  }

                  if (audioPlayer.current.value.audio.assetAudioPath ==
                      "http://www.musicapi.online/music/${widget.datos[widget.index][0]['ruta']}") {
                    return Icon(
                      Icons.check,
                      color: Colors.greenAccent,
                    );
                  } else {
                    return SizedBox();
                  }
                }),
                CircleAvatar(
                  radius: 23.5,
                  child: Image.asset(
                    "assets/icon/icon.png",
                  ),
                ),
                Spacer(),
                SizedBox(
                    width: 120,
                    child: Text("${widget.datos[widget.index][0]['name']}",
                        style: TextStyle(fontSize: 11, color: Colors.black))),
                Spacer(),
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
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => adicionarPlaylist(
                              music_id: widget.datos[widget.index][0]['id'],
                              id: widget.id)));
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
