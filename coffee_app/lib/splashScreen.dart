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

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _myAnimationController;
  Animation _myAnimation;

  @override
  void initState() {
    super.initState();
    _myAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _myAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_myAnimationController);
    startTime();
  }

  @override
  dispose() {
    _myAnimationController.dispose();
    super.dispose();
  }

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/HomeScreen');
  }

  @override
  Widget build(BuildContext context) {
    _myAnimationController.forward();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image(
            image: AssetImage("assets/Asset1.jpeg"),
            fit: BoxFit.fitHeight,
            color: Colors.black54,
            colorBlendMode: BlendMode.darken,
          ),
          FadeTransition(
            opacity: _myAnimation,
                      child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints.loose(Size.fromHeight(250.0)),
                  child: Image(
                    image: AssetImage('assets/coffeeCompass.png'),
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "BrewCompass",
                        style: Styles.splashScreenTitleText,
                      ),
                    ),
                  ],
                ),
                Row(
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
          ),
        ],
      ),
    );
  }
}
