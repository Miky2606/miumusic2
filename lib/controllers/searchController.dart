import 'package:http/http.dart' as http;
import 'package:miumusic/controllers/api.dart';

var api = new Api();

class Search {
  getFinder(value, type, id) async {
    if (id == "null") {
      var response = await http.post("${api.api}buscarPlaylist/",
          body: {"value": "$value", "type": "public", "id": "null"});

      return response.body;
    } else {
      var response = await http.post("${api.api}buscarPlaylist/",
          body: {"value": "$value", "id": "${id}"});

      return response.body;
    }
  }

  getMusic(token, value) async {
    var data = {"search": value};
    var response = await http.post("${api.api}searchMusic",
        headers: {"token": token}, body: data);

    return response.body;
  }
}
