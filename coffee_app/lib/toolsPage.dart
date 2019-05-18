import 'package:coffee_app/caculator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabbedPage extends StatefulWidget {
  const TabbedPage({ Key key }) : super(key: key);
  @override
  TabbedPageState createState () => TabbedPageState();
}

class TabbedPageState extends State<TabbedPage> with SingleTickerProviderStateMixin {

  //label for tabs
final List<Tab> myTabs = <Tab>[
    Tab(text: 'Caculator'),
    Tab(text: 'Stopwatch'),
  ];

  //wrapping tabs into a tabBar
  final TabBar toolBar = new TabBar(
    tabs: <Tab>[
      new Tab(text: 'Caculator'),
      new Tab(text: 'StopWatch'),
    ]);


  @override
  Widget build(BuildContext context){
    return new DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: new PreferredSize(
                preferredSize: toolBar.preferredSize,
                child: new Card(
                  elevation: 5.0,
                  color: Theme.of(context).primaryColor,
                  child: toolBar,
                  )),

                body: TabBarView(
                  children: <Widget>[
                    new MyCalcPage(),
                    new Text("Test1"),
                  ]
                ),
              ), 
            );
  }
}
