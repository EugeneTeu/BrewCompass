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
         
               
                 
                  
                
              
            ],
          ),
        ],
      ),
    );
  }
}
