import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:miumusic/controllers/musicController.dart';
import 'package:miumusic/controllers/reproductor.dart';
import 'package:miumusic/home/pages/local.dart';

var reproducir = new Reproductor();
var msuciController = new Music();

class vacioPlaylist extends StatefulWidget {
  final id;
  final id_user;
  final currentUser;
  final name;
  final type;
  vacioPlaylist(
      {Key key, this.name, this.id_user, this.id, this.type, this.currentUser})
      : super(key: key);

  @override
  _vacioPlaylistState createState() => _vacioPlaylistState();
}

class _vacioPlaylistState extends State<vacioPlaylist> {
  bool type;
  @override
  void initState() {
    setState(() {
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
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
                          setState(() {
                            type = value;
                          });
                        },
                        activeColor: Colors.red,
                      )),
                      Icon(Icons.lock_open),
                      IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            var response = await musicController.deletePlaylist(
                                context, widget.id);
                          })
                    ],
                  )
                : SizedBox(),
          ],
        ),
        body: Container(
          height: size.height,
          child: Center(
            child: ListView(children: [
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("No hay music"),
              )),
              Image.asset("assets/pictures/escuchando.png"),
            ]),
          ),
        ));
  }
}
