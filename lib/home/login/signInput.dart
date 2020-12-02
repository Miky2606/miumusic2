import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:miumusic/home/scaffold.dart';

class signInput extends StatefulWidget {
  signInput({Key key}) : super(key: key);

  @override
  _signInputState createState() => _signInputState();
}

class _signInputState extends State<signInput> {
  final form = GlobalKey<FormState>();
  String _email, password, user;
  bool hide;
  bool isLoading;
  void initState() {
    setState(() {
      hide = true;
      isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: form,
      child: ListView(children: [
        isLoading == true ? CircularProgressIndicator() : Divider(),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextFormField(
            validator: (value) => value.length < 5
                ? "Username debe de tener minimo 5 caracteres"
                : null,
            onSaved: (value) => user = value,
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                labelText: "UserName",
                hintText: "Username",
                prefixIcon: Icon(Icons.account_circle),
                focusColor: Colors.red),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextFormField(
            validator: (value) =>
                !value.contains('@') ? "Email Incorrecto" : null,
            onSaved: (value) => _email = value,
            decoration: InputDecoration(
                labelText: "Email",
                hintText: "Email",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextFormField(
            onSaved: (value) => password = value,
            validator: (value) => value.length < 5
                ? "Password debe de tener minimo 5 caracteres"
                : null,
            obscureText: hide,
            decoration: InputDecoration(
                labelText: "Password",
                hintText: "Password",
                prefixIcon: Icon(Icons.lock),
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      hide = !hide;
                    });
                  },
                  child: Icon(Icons.remove_red_eye, color: Colors.black),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12))),
          ),
        ),
        IconButton(
            icon: Icon(Icons.check, size: 35, color: Colors.pink),
            onPressed: () {
              if (form.currentState.validate()) {
                form.currentState.save();
                userData.signin(user, _email, password, context);
              }
            })
      ]),
    );
  }
}
