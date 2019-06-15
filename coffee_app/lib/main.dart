import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'auth.dart';
import 'root.dart';
import 'splashScreen.dart';

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  return runApp(
      new MaterialApp(home: new SplashScreen(), routes: <String, WidgetBuilder>{
    '/HomeScreen': (BuildContext context) => new MyApp(),
  }));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        accentColor: Colors.brown[200],
        primaryColor: Colors.brown[200],
        brightness: Brightness.light,
        
      ),
      home: new RootPage(auth: new Auth()),
    );
  }
}


