import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:miumusic/controllers/api.dart';
import 'package:miumusic/controllers/notification.dart';
import 'package:miumusic/home/pages/local.dart';
import 'package:miumusic/home/scaffold.dart';
import 'package:permission_handler/permission_handler.dart';

var api = new Api();
var notification = new Notificacion();
Dio dio = Dio();

class Music {
//get all music

  Future<String> getMusic() async {
    var response = await http.get("${api.api}musicAll/");

    return response.body;
  }

  subir(id, context) {
    Map response;
    List data;
    var text;
    http.get('${api.api}youtube/$id').then((value) {
      response = jsonDecode(value.body);

      if (response['error'] == "ya existe") {
        text = "La cancion ya existe";
        notification.error(text, context);
      } else {
        text = "Se ha subido exitosamente la cancion";
        notification.success(context, text);
      }
    });
    return false;
  }

  //Playlists publics

  Future<String> get playlists async {
    var response = await http.get("${api.api}playlistPublicAll");

    return response.body;
  }

//Playlists User

  Future<String> playlistsUser(id) async {
    var response = await http.get("${api.api}playlistUser/${id}");

    return response.body;
  }

  //Playlist Delete Fav

  deletePlaylistFav(id_user, id, context) async {
    var response = await http.post("${api.api}deletePlaylistFav/",
        body: {"id_user": "${id_user}", "id_playlist": "${id}"});
    Map respuesta = jsonDecode(response.body);
    if (respuesta['playlist'] == "delete") {
      var text = "Playlist Eliminada";
      notification.flushbarSnackbarError(context, text);
    }
    return true;
  }

  //Playlist Add Fav

  addPlaylistFav(id_user, id, name, context) async {
    var response = await http.post("${api.api}addPlaylistFav/", body: {
      "id_user": "${id_user}",
      "id_playlist": "${id}",
      "name": "${name}"
    });
    Map respuesta = jsonDecode(response.body);
    if (respuesta['playlist'] == "add") {
      var text = "Playlist Adicionada";
      notification.flushbarSnackbarSuccess(context, text);
    }
    return true;
  }

//Playlist Save User
  getPlaylistSave(id, id_user) async {
    var response;
    if (id == null) {
      var response = await http.post("${api.api}selectPlaylistFav/",
          body: {"id_user": "${id_user}"});
      print(response.body);
      Map respuesta = jsonDecode(response.body);
      if (respuesta['playlist'] == "vacio") {
        return respuesta['playlist'];
      }
      return respuesta['playlist'];
    } else {
      response = await http.post("${api.api}selectPlaylistFav/",
          body: {"id_user": "${id_user}", "id_playlist": "${id}"});
      Map respuesta = jsonDecode(response.body);
      if (respuesta['playlist'] == "vacio") {
        return false;
      } else {
        return true;
      }
    }
  }

  //Download Music

  downloadMusic(context, ruta, name, extname) async {
    var status = await Permission.storage.status;
    var progress;

    if (status.isUndetermined) {
      var text = "Necesitamos los permisos del storage";
      notification.permission(text, context);
    } else {
      final taskId = await FlutterDownloader.enqueue(
        url: "${api.api}music/${ruta}",
        savedDir: 'sdcard/download/',
        fileName: "${name}.${extname[1]}",
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      );

      /*  var path = "sdcard/download/${name}.${extname[1]}";
      var response = await dio
          .download("http://www.musicapi.online/music/${ruta}", path,
              onReceiveProgress: (cont, total) {
        progress = ((cont / total) * 100);
      }); */
    }
  }

  //Delete Playlist

  deletePlaylist(context, id) async {
    var response = await http.delete("${api.api}deletePlaylist/${id}");
    Map music = jsonDecode(response.body);
    if (music['music'] == "eliminado") {
      var text = "Playlist Eliminada";
      notification.flushbarSnackbarSuccess(context, text);
      Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (context) => scaffold()));
    } else {
      return false;
    }
  }
}
