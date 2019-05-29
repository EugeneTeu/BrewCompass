import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/HomeScreen');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Image(
            image: new AssetImage("assets/Asset1.jpeg"),
            fit: BoxFit.fitHeight,
            color: Colors.black54,
            colorBlendMode: BlendMode.darken,
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new ConstrainedBox(
                constraints: BoxConstraints.loose(Size.fromHeight(250.0)),
                child: Image(
                  image: new AssetImage('assets/coffeeCompass.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "BrewCompass",
                      style: TextStyle(
                          fontFamily: "sans-serif",
                          fontSize: 55.0,
                          color: Colors.white70,
                          fontStyle: FontStyle.italic),
                    ),
                  )
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Your Specialty Coffee Companion",
                        style: TextStyle(
                            fontFamily: "sans-serif",
                            fontSize: 20.0,
                            color: Colors.white54,
                            fontStyle: FontStyle.italic),
                      ))
                ],
              ),
              new Form(
                child: new Theme(
                  data: new ThemeData(
                    brightness: Brightness.dark,
                    primaryColor: Colors.white,
                    primarySwatch: Colors.grey,
                    accentColor: Colors.brown[400],
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    child: new Column(
                      children: <Widget>[
                        new TextFormField(
                          decoration:
                              new InputDecoration(hintText: "Enter Username"),
                          keyboardType: TextInputType.emailAddress,
                          obscureText: false,
                        ),
                        new TextFormField(
                          decoration:
                              new InputDecoration(hintText: "Enter password"),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                        ),
                        new Padding(
                          padding: EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                        ),
                        new MaterialButton(
                          color: Colors.brown[400],
                          child: Text("Login"),
                          onPressed: () {
                            print("login!");
                          },
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
