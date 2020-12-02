import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Notificacion {
  error(text, context) {
    return showCupertinoDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("$text"),
            actions: [
              IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  success(context, text) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Logrado"),
            content: Text("$text"),
            actions: [
              FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  //Snackbar success

  flushbarSnackbarSuccess(context, text) {
    Flushbar(
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      message: "$text",
      icon: Icon(
        Icons.check,
        size: 28.0,
        color: Colors.green,
      ),
      duration: Duration(seconds: 2),
    )..show(context);
  }

  //Snackbar error
  flushbarSnackbarError(context, text) {
    Flushbar(
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      message: "$text",
      icon: Icon(
        Icons.error,
        size: 28.0,
        color: Colors.red,
      ),
      duration: Duration(seconds: 2),
    )..show(context);
  }

  //permission

  permission(text, context) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: Text("$text"), actions: [
            IconButton(
                icon: Icon(Icons.check, color: Colors.green),
                onPressed: () async {
                  Map<Permission, PermissionStatus> statuses = await [
                    Permission.storage,
                  ].request();
                  Navigator.pop(context);
                  return true;
                }),
            IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.red,
                ),
                onPressed: () {
                  Navigator.pop(context);
                })
          ]);
        });
  }
}
