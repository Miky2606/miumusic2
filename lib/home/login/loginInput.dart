import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:miumusic/controllers/modal.dart';
import 'package:miumusic/controllers/social.dart';
import 'package:miumusic/controllers/userController.dart';
import 'package:miumusic/home/scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

var userData = new User();
var modal = new Modal();
var social = new Social();

class loginInput extends StatefulWidget {
  loginInput({Key key}) : super(key: key);

  @override
  _loginInputState createState() => _loginInputState();
}

class _loginInputState extends State<loginInput> {
  final form = GlobalKey<FormState>();
  var textController = TextEditingController();
  String _email, password, user, error;
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
    var size = MediaQuery.of(context).size;
    return Form(
      key: form,
      child: ListView(children: [
        isLoading == true
            ? Center(child: CircularProgressIndicator())
            : Divider(),
        error == null ? Divider() : Text("$error"),
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  var body = modalLogin(textController, size);
                  modal.modal(context, body);
                },
                child: Text(
                  "Olvidaste el password?",
                  style: TextStyle(color: Colors.red),
                ),
              )),
        ),
        IconButton(
            icon: Icon(Icons.check, size: 35, color: Colors.pink),
            onPressed: () async {
              if (form.currentState.validate()) {
                form.currentState.save();
                var loading = await userData.login(_email, password, context);

                setState(() {
                  isLoading = loading;
                });
              }
            })
      ]),
    );
  }

  Container modalLogin(email, size) => Container(
        height: size.height * .6,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text("Ponga el email de su cuenta",
                      style: TextStyle(fontSize: 25))),
            ),
            Center(child: Text("Se le enviara un email con un nuevo password")),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: email,
                decoration: InputDecoration(
                  hintText: 'hola',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    userData.forgetPassword(email.text, context);
                  }),
            ),
            Center(
                child: Text("Siguenos en nuestras redes sociales:",
                    style: TextStyle(fontSize: 21))),
            FutureBuilder(
                future: social.findSocial,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  Map redes = jsonDecode(snapshot.data);
                  List tipoRedes = redes['redes'];

                  return Center(
                    child: Container(
                      height: size.height * .3,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: tipoRedes.length,
                          itemBuilder: (context, index) {
                            print(tipoRedes[index]);
                            return Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: InkWell(
                                  child: tipoRedes[index]['red'] == "instagram"
                                      ? Image.asset(
                                          "assets/pictures/instagram.png",
                                          width: size.width * .1)
                                      : Image.asset(
                                          "assets/pictures/facebook.png",
                                          width: size.width * .1),
                                  onTap: () async {
                                    social.openRutas(tipoRedes[index]['ruta']);
                                  }),
                            );
                          }),
                    ),
                  );
                })
          ],
        ),
      );
}
