import 'package:coffee_app/auth.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  TestPage(this.auth);
  final BaseAuth auth;
  @override
  State<StatefulWidget> createState() => TestPageState();
}

class TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Center(
        child: Text("This is a test page"),
      ),
    );
  }
}
