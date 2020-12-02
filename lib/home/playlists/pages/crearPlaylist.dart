import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class crearPlaylist extends StatefulWidget {
  final id;
  crearPlaylist({Key key, this.id}) : super(key: key);

  @override
  _crearPlaylistState createState() => _crearPlaylistState();
}

class _crearPlaylistState extends State<crearPlaylist> {
  final scaffold = GlobalKey<ScaffoldState>();
  final nameController = TextEditingController();
  bool status = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffold,
      appBar: AppBar(),
      body: Container(
          height: size.height * 1,
          child: ListView(
            children: [
              Center(child: Text("crear")),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                        labelText: "Nombre Playlist",
                        hintText: "Nombre Playlist",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12))),
                  ),
                ),
              ),
              SizedBox(
                width: size.width * 0.9,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text("Public"),
                      Spacer(),
                      Switch(
                          activeColor: Colors.red[300],
                          value: status,
                          onChanged: (value) {
                            setState(() {
                              status = value;
                            });
                          }),
                      Spacer(),
                      Text("privado")
                    ],
                  ),
                ),
              ),
              status == true
                  ? Padding(
                      padding: const EdgeInsets.all(36.0),
                      child: Image.asset(
                        "assets/pictures/espia.png",
                        height: 200,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(36.0),
                      child: Image.asset(
                        "assets/pictures/publico.png",
                        height: 200,
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: IconButton(
                  onPressed: () async {
                    var datos;
                    if (nameController.text == "") {
                      final snackbar = SnackBar(
                          content: Text("Nombre no debe estar en blanco"),
                          duration: Duration(seconds: 1));
                      scaffold.currentState.showSnackBar(snackbar);
                    } else {
                      if (status == false) {
                        datos = {
                          "id_user": "${widget.id}",
                          "name": "${nameController.text}",
                          "type": "public"
                        };
                      } else {
                        datos = {
                          "id_user": "${widget.id}",
                          "name": "${nameController.text}",
                          "type": "privado"
                        };
                      }
                      var response = await http.post(
                          "http://www.musicapi.online/crearPlaylist/",
                          body: datos);

                      print(response.body);
                      Map message = jsonDecode(response.body);
                      if (message['playlist'] == "Exist Playlist") {
                        final snackbar = SnackBar(
                            content: Text("Playlist ya existe"),
                            duration: Duration(seconds: 1));
                        scaffold.currentState.showSnackBar(snackbar);
                      } else {
                        final snackbar = SnackBar(
                            content: Text("Playlist creada"),
                            duration: Duration(seconds: 1));
                        scaffold.currentState.showSnackBar(snackbar);
                      }
                    }
                  },
                  icon: Icon(
                    Icons.check,
                    size: 36,
                    color: Colors.pink,
                  ),
                ),
              )
            ],
          )),
    );
  }
}
