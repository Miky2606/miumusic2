import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'home/scaffold.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.greenAccent[200], accentColor: Colors.cyan),
      title: 'MiuMusic',
      home: scaffold(token: null),
    );
  }
}
