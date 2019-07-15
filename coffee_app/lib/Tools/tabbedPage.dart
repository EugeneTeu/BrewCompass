import 'package:coffee_app/Tools/caculator.dart';
import 'package:coffee_app/Tools/stopwatch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'converter.dart';


class TabbedPage extends StatefulWidget {
  const TabbedPage({ Key key }) : super(key: key);

  @override
  TabbedPageState createState () => TabbedPageState();
}

class TabbedPageState extends State<TabbedPage> with SingleTickerProviderStateMixin {
  //wrapping tabs into a tabBar
  final TabBar toolBar = new TabBar(
    
    unselectedLabelColor: Colors.black38,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
      insets: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0)
    ),
    indicatorColor: Colors.blueGrey,
    tabs: <Tab>[
      new Tab(text: 'Convertor'),
      new Tab(text: 'StopWatch'),
      new Tab(text: 'Calculator'),
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
                    elevation: 0.0,
                    color: Colors.white70,
                    child: toolBar,
                    ),
                )),

                body: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    MyConverter(),
                    MyStopWatch(),
                    MyCalcPage(),
                  ]
                ) 
              ), 
            );
  }

 
}
