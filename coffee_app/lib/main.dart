import 'package:coffee_app/auth_provider.dart';
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
      new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: new SplashScreen(), routes: <String, WidgetBuilder>{
    '/HomeScreen': (BuildContext context) => new MyApp(),
  }));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth:Auth(),
          child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'OpenSans',
          accentColor: Colors.brown[500],
          primaryColor: Colors.brown[200],
          brightness: Brightness.light,
          
          
        ),
        home: new RootPage(),
      ),
    );
  }
}


