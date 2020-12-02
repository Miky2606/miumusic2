import 'package:file_picker/file_picker.dart';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:io';

import 'package:miumusic/home/pages/local.dart';

class online extends StatefulWidget {
  online({Key key}) : super(key: key);

  @override
  _onlineState createState() => _onlineState();
}

class _onlineState extends State<online> {
  bool escoger;
  File doc;
  bool loading;
  @override
  void initState() {
    setState(() {
     
      loading = false;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController idYoutube = TextEditingController();
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: ListView(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                      width: size.width * .5,
                      height: size.height * .1,
                      child: Text(
                        "Sube Tu Musica ",
                        style: TextStyle(fontSize: 23),
                      )),
                ),
              ),
              loading == true
                  ? SizedBox(
                      width: size.width * .5,
                      height: size.height * .3,
                      child: FlareActor(
                        'assets/animation/uploading.flr',
                        animation: 'uploading',
                      ))
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                          controller: idYoutube,
                          decoration:
                              InputDecoration(hintText: "Youtube Video Id")),
                    ),
              IconButton(
                icon: Icon(Icons.upload_file),
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });

                  var response =
                      await musicController.subir(idYoutube.text, context);
                  if (response == false) {
                    setState(() {
                      loading = false;
                    });
                  }
                },
              ),
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: size.width * .6,
                  child: Padding(
                    padding: const EdgeInsets.all(42.0),
                    child: Text(
                      " Welcome ",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
