import 'dart:convert';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:http/http.dart' as http;
import 'package:miumusic/controllers/api.dart';
import 'package:miumusic/controllers/notification.dart';

var api = Api();
var notification = new Notificacion();
AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId("0");
List<Audio> musicPlaylist = [];

class Reproductor {
  //get music

  Future<void> getDatos(id) async {
    var response = await http.get("${api.api}musicFindPlaylist/${id}");

    return response.body;
  }

  //play sibgle music

  reproducirSolo(ruta, name, autor, album) {
    audioPlayer.open(
        Audio.network("${api.api}music/${ruta}",
            metas: Metas(
                title: name,
                artist: autor,
                album: album,
                image: MetasImage.asset("assets/icon/icon.png"))),
        showNotification: true,
        headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
        notificationSettings: NotificationSettings(
          stopEnabled: false,
        ));
    ;
  }

  //Delete music playlist

  deleteMusicPlaylist(id, datos, id_playlist, context) async {
    print(id);
    var response =
        await http.delete("${api.api}deleteMusicPlaylist/${id}/${id_playlist}");
    print(response.body);
    Map message = jsonDecode(response.body);
    if (message['music'] == "eliminado") {
      var text = "Musica Eliminada";
      if (datos == 1) {
        return true;
      } else {
        notification.flushbarSnackbarError(context, text);
        return false;
      }
    }
  }

  //add Music playlist

  addMusicPlaylisrt(datos) {
    List<Audio> music = [];
    for (var i = 0; i < datos.length; i++) {
      music.add(Audio.network("${api.api}music/${datos[i][0]['ruta']}",
          metas: Metas(
              title: datos[i][0]['name'],
              artist: datos[i][0]['autor'],
              album: datos[i][0]['album'],
              image: MetasImage.asset("assets/icon/icon.png"))));
    }
    return music;
  }

  //Play Playlist

  reproducirPlaylist(playlist) {
    audioPlayer.open(
        Playlist(
          audios: playlist,
        ),
        showNotification: true,
        loopMode: LoopMode.playlist,
        headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
        notificationSettings: NotificationSettings(
          stopEnabled: false,
        ));
  }

//update type playlist
  updateMusic(id, typeChange, context) async {
    var response = await http.post("${api.api}updatePlaylistType/",
        body: {"id": "${id}", "type": "${typeChange}"});

    Map message = jsonDecode(response.body);

    if (message['message'] == "update") {
      var text = "Actualizado: Su playlist es ahora ${typeChange}";
      notification.flushbarSnackbarSuccess(context, text);
      return true;
    }
  }
}
