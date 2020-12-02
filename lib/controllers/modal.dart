import 'package:flutter/material.dart';

class Modal {
  modal(context, body) {
    showModalBottomSheet(
        backgroundColor: Colors.greenAccent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        context: context,
        builder: (context) {
          return body;
        });
  }
}
