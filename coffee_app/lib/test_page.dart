import 'package:coffee_app/tabbedPage.dart';
import 'package:coffee_app/tabbedPageMain.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TestPageState();
}

class TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 10.0,),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(20.0),
              color: Colors.grey[300],
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Image(
                    image: AssetImage('assets/coffeeCompass.png'),
                    fit: BoxFit.fitHeight,
                  ),
                  new Text("Username"),
                  new SizedBox(height: 10.0,width: 40.0,)
                ],),
              ),),
          SizedBox(height:30.0),
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.white,
              child: new TabbedPageMain(),
              ),)
        ],
      ),
        
      
    
    ); 
  }
}
