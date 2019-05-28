import 'package:coffee_app/caculator.dart';
import 'package:coffee_app/page.dart';
import 'package:coffee_app/stopwatch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TabbedPageMain extends StatefulWidget {
  const TabbedPageMain({ Key key }) : super(key: key);
  @override
  TabbedPageMainState createState () => TabbedPageMainState();
}

class TabbedPageMainState extends State<TabbedPageMain> with SingleTickerProviderStateMixin {



  //wrapping tabs into a tabBar
  final TabBar toolBar = new TabBar(
    unselectedLabelColor: Colors.black38,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
      insets: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0)
    ),
    indicatorColor: Colors.blueGrey,
    tabs: <Tab>[
      new Tab(text: 'Brew'),
      new Tab(text: 'Journal'),
      new Tab(text: "Your Gear")
    ]);


  @override
  Widget build(BuildContext context){
    return new DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: new PreferredSize(
                preferredSize: toolBar.preferredSize,

                child: new Container(
                  padding: EdgeInsets.all(0.0),
                  child: new Card(
                    shape: new ContinuousRectangleBorder(borderRadius: new BorderRadius.horizontal()),
                    margin: EdgeInsets.all(0.0),
                    elevation: 50.0,
                    color: Theme.of(context).primaryColor,
                    child: toolBar,
                    ),
                )),

                body: TabBarView(
                  children: <Widget>[
                    new PageTest("brews"),
                    new PageTest("journals"),
                    new PageTest("grind gear")
                   
                  ]
                ),
              ), 
            );
  }
}
