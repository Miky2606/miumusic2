import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class loading extends StatefulWidget {
  loading({Key key}) : super(key: key);

  @override
  _loadingState createState() => _loadingState();
}

class _loadingState extends State<loading> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: FlareActor(
      "assets/animation/loading.flr",
      animation: "searching",
    )));
  }
}
