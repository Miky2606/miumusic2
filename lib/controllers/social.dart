import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:miumusic/controllers/api.dart';
import 'package:url_launcher/url_launcher.dart';

var api = new Api();

class Social {
  Future<String> get findSocial async {
    var response = await http.get("${api.api}getSocial");

    return response.body;
  }

  openRutas(ruta) async {
    if (await canLaunch(ruta)) {
      await launch(ruta);
    } else {
      throw 'Could not launch $ruta';
    }
  }
}
