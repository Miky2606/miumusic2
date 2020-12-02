import 'package:flutter/material.dart';
import 'package:miumusic/home/login/loginInput.dart';
import 'package:miumusic/home/login/signInput.dart';

class login extends StatefulWidget {
  login({Key key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  bool status;
  @override
  void initState() {
    setState(() {
      status = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("hola")),
        ),
        body: Container(
          child: ListView(
            children: [
              Container(
                  height: size.height * .3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(55),
                          bottomLeft: Radius.circular(55))),
                  child: Stack(children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Text("Sign"),
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
                          Text("Login"),
                        ],
                      ),
                    ),
                  ])),
              Container(
                  height: size.height * .56,
                  color: Colors.transparent,
                  child: status == false ? signInput() : loginInput())
            ],
          ),
        ));
  }
}
