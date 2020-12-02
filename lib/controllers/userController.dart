import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:miumusic/home/scaffold.dart';

import 'api.dart';
import 'notification.dart';

DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

var api = new Api();
var notification = new Notificacion();

class User {
//get user

//know if exist token

  Future<String> getToken() async {
    var storage = FlutterSecureStorage();
    var token = await storage.read(key: "token");
    if (token == null) {
      return "null";
    }

    return token;
  }

  //find data user

  Future<String> get datosUser async {
    var storage = FlutterSecureStorage();
    var token = await storage.read(key: "token");
    var response = await http.get("${api.api}home", headers: {"token": token});

    return response.body;
  }

  //login

  login(_email, password, context) async {
    var datos = {"email": "$_email", "password": "$password"};

    var response = await http.post("${api.api}login", body: datos);

    if (response.body == "errorEmail" || response.body == "errorPassword") {
      var text;
      switch (response.body) {
        case "errorEmail":
          text = "Email es incorrecto";
          notification.error(text, context);

          break;
        case "errorPassword":
          text = "Password es incorrecto";
          notification.error(text, context);

          break;
      }
      return false;
    } else {
      Map token = json.decode(response.body);
      /*   setState(() {
          isLoading = true;
        }); */

      if (token != null) {
        var storage = FlutterSecureStorage();
        var tokenStorage = storage.write(key: "token", value: token["token"]);
        Navigator.of(context).pushReplacement(
            CupertinoPageRoute(builder: (context) => scaffold()));
      }
      return false;
    }
  }

  //signin

  Future<String> signin(user, _email, password, context) async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    var datos = {
      "user": "$user",
      "email": "$_email",
      "password": "$password",
      "device": "${androidInfo.model}",
      "os": "${Platform.operatingSystem}"
    };

    var response = await http.post("${api.api}inicio", body: datos);
    if (response.body == "error") {
      var text = "El Usuario o el Email ya existen";
      notification.error(text, context);
    } else {
      Map token = json.decode(response.body);

      if (token != null) {
        var storage = FlutterSecureStorage();
        var tokenStorage = storage.write(key: "token", value: token["token"]);
        Navigator.of(context).pushReplacement(
            CupertinoPageRoute(builder: (context) => scaffold()));
      }
    }
  }

  //logout

  void logout(context) async {
    var storage = FlutterSecureStorage();
    var delete = await storage.delete(key: "token");

    Navigator.of(context)
        .pushReplacement(CupertinoPageRoute(builder: (context) => scaffold()));
  }

  //Forget Password

  forgetPassword(email, context) async {
    var response =
        await http.post("${api.api}forgetPassword", body: {"email": "$email"});
    Map emailSend = jsonDecode(response.body);
    if (emailSend['password'] == "updated") {
      var text = "Se ha enviado un email con su nuevo password ";
      notification.success(context, text);
    }
  }

  changePassword(password, id, context) async {
    var text;
    var response = await http.post("${api.api}changePassword",
        body: {"id": "$id", "password": "$password"});
    Map change = jsonDecode(response.body);
    if (change['change'] == "success") {
      text = "Password Actualizado";
      notification.flushbarSnackbarSuccess(context, text);
    } else {
      text = "Hubo un error";
      notification.flushbarSnackbarError(context, text);
    }
  }
}
