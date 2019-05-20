import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Profile();
  }

}

class _Profile extends State<Profile> {
  String name;
  String title;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: new Container(
          alignment: Alignment.center ,
          color: Theme.of(context).primaryColor,
          child: new Text("*Username*" , style: new TextStyle(color: Colors.white
          ),),
      ),
      ),
      body: new Text("build layers here"),

    );
  }
}