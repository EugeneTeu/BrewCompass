import 'package:coffee_app/Tools/caculator.dart';
import 'package:coffee_app/Tools/stopwatch.dart';
import 'package:coffee_app/styles.dart';
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
  TabBar toolBar = new TabBar(
    
    unselectedLabelColor: Colors.black38,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
      insets: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0)
    ),
    indicatorColor: Colors.brown[400],
    tabs: <Tab>[
      Tab(child: Text("Convertor", style: Styles.utilityTabBarText,)),
      Tab(child: Text("StopWatch", style: Styles.utilityTabBarText,)),
      Tab(child: Text("Calculator", style: Styles.utilityTabBarText,)),
    ]);

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar:  PreferredSize(
                preferredSize: toolBar.preferredSize,
                child:  Container(
                  padding: EdgeInsets.all(0.0),
                  child: Card(
                    shape:  ContinuousRectangleBorder(borderRadius:  BorderRadius.horizontal()),
                    margin: EdgeInsets.all(0.0),
                    elevation: 0.0,
                    color: Colors.white,
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
