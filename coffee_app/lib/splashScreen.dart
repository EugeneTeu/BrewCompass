import 'dart:async';

import 'package:coffee_app/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/HomeScreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
               ConstrainedBox(
                constraints: BoxConstraints.loose(Size.fromHeight(250.0)),
                child: Image(
                  image: AssetImage('assets/coffeeCompass.png'),
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
                      style: Styles.splashScreenTitleText,
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
                            fontFamily: "Montserrat",
                            fontSize: 20.0,
                            color: Colors.white54,
                            fontStyle: FontStyle.italic),
                      ))
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
