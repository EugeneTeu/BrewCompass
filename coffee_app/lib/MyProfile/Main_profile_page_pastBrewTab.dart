
import 'package:coffee_app/MyProfile/Main_profile_page_pastBrewTab_content.dart';
import 'package:coffee_app/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class PastBrewTab extends StatefulWidget {
  const PastBrewTab({ Key key}) : super(key: key);
  

  @override
  PastBrewTabState createState() => PastBrewTabState();
}

class PastBrewTabState extends State<PastBrewTab>
    with SingleTickerProviderStateMixin {

  //wrapping tabs into a tabBar
  final TabBar toolBar = new TabBar(
      unselectedLabelColor: Colors.black38,
      labelColor: Colors.black,
      indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
          insets: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0)),
      indicatorColor: Colors.blueGrey,

      tabs: <Tab>[
        new Tab(text: 'Journal'),
      ]);

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: new PreferredSize(
            preferredSize: toolBar.preferredSize,
            child: new Container(
              padding: EdgeInsets.all(0.0),
              child: new Card(
                shape: new ContinuousRectangleBorder(
                    borderRadius: new BorderRadius.horizontal()),
                margin: EdgeInsets.all(0.0),
                elevation:0.0,
                color: Colors.white,
                child: toolBar,
              ),
            )),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
          new PastBrews(),
        ]),
      ),
    );
  }
}
