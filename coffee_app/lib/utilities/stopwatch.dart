import 'package:flutter/material.dart';
import 'timer_page.dart';

class StopWatch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      showPerformanceOverlay: false,
      title: 'Flutter Demo',
      theme: Theme.of(context),
      home: new MyStopWatch(),
    );
  }
}

class MyStopWatch extends StatelessWidget {
  MyStopWatch({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        child: new TimerPage()
      ),
    );
  }
}