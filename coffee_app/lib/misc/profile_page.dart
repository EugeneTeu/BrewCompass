import 'package:coffee_app/firstPageTabs/tabbedPageMain.dart';
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
    return new Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: new BoxDecoration(
                border: new Border.all(
                  color: Colors.black45,
                  style: BorderStyle.solid,
                  width: 2.0,
                )
              ),
              padding: EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Image(
                    image: AssetImage('assets/coffeeCompass.png'),
                    fit: BoxFit.fitHeight,
                  ),
                  new Text("Username"),
                  new SizedBox(
                    height: 10.0,
                    width: 40.0,
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 30.0,),
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.white,
              child: new TabbedPageMain(),
            ),
          )
        ],
      ),
    );
  }
}