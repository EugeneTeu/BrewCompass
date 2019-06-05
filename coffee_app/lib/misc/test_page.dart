import 'package:flutter/material.dart';

import '../firstPageTabs/tabbedPageMain.dart';

class TestPage extends StatefulWidget {
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
