import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../styles.dart';
import 'dart:io' show Platform;

class ElapsedTime {
  ElapsedTime({
    this.hundreds,
    this.seconds,
    this.minutes,
  });

  final int hundreds;
  final int minutes;
  final int seconds;
}

class Dependencies {
  final Stopwatch stopwatch = new Stopwatch();
  final TextStyle textStyle =
      const TextStyle(fontSize: 90.0, fontFamily: "Bebas Neue");
  final TextStyle textStyleLap =
      const TextStyle(fontSize: 30.0, fontFamily: "Bebas Neue");
  final List<ValueChanged<ElapsedTime>> timerListeners =
      <ValueChanged<ElapsedTime>>[];
  final int timerMillisecondsRefreshRate = 30;
}

class TimerPage extends StatefulWidget {
  TimerPage({Key key}) : super(key: key);

  TimerPageState createState() => new TimerPageState();
}

class TimerPageState extends State<TimerPage> {
  final Dependencies dependencies = new Dependencies();

  void p() {
    for (int i = 0; i < lapTimes.length; ++i) {
      print("ms: ${lapTimes[i]}, formatted: ${formatMilliseconds(lapTimes[i])}");
    }
  }

  void leftButtonPressed() {
    setState(() {
      if (dependencies.stopwatch.isRunning) {
        // lap function: want to print this to the UI instead
        // print("${dependencies.stopwatch.elapsedMilliseconds}");
        setState(() {
          lapTimes.insert(0, dependencies.stopwatch.elapsedMilliseconds);
        });
        // p();
      } else {
        dependencies.stopwatch.reset();
        setState(() {
          lapTimes = [];
        });
      }
    });
  }

  void rightButtonPressed() {
    setState(() {
      if (dependencies.stopwatch.isRunning) {
        dependencies.stopwatch.stop();
      } else {
        dependencies.stopwatch.start();
      }
    });
  }

  Widget buildFloatingButton(String text, VoidCallback callback) {
    TextStyle roundTextStyle = Styles.calcFont;
    return (Platform.isAndroid)
        ? RaisedButton(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20)),
            color: Theme.of(context).accentColor,
            child: new Text(text, style: roundTextStyle),
            onPressed: callback)
        : CupertinoButton(
            color: Theme.of(context).accentColor,
            child: new Text(text, style: roundTextStyle),
            onPressed: callback);
  }

  String formatMilliseconds(int milliseconds) {
    print("@@@@@@@@@@@@");
    print("formatting $milliseconds");
    int hundreds = (milliseconds / 10).truncate();
    print("hundreds: $hundreds");
    int seconds = (hundreds / 100).truncate();
    print("seconds first: $seconds");
    int minutes = (seconds / 60).truncate();
    print("minutes: $minutes");
    seconds = ((hundreds / 100).truncate()) % 60;
    print("seconds mod 60: $seconds");
    print("returning: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${hundreds.toString().substring(0, 2).padLeft(2, '0')}");
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${hundreds.toString().substring(0, 2).padLeft(2, '0')}";
  }

  List<int> lapTimes = [];

  Widget _buildLapTimes() {
    return Card(
      color: Colors.white70,
      elevation: 8.0,
          child: Container(
        
        //decoration: BoxDecoration(border: Border(bottom:BorderSide(color: Theme.of(context).accentColor), top: BorderSide(color: Theme.of(context).accentColor))),
        height: 200.0,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: lapTimes.length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width / 1.5,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Theme.of(context).accentColor,
                                      width: 5.0))),
                          child: Center(
                            child: ListTile(
                              leading: Text(
                                //hjkjlklkj
                                "Lap " + (lapTimes.length - index).toString() + ": ",
                                style: dependencies.textStyleLap,
                              ),
                              title: Text(
                                formatMilliseconds(lapTimes[index]),
                                style: dependencies.textStyleLap,
                              ),
                            ),
                          )),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        new Expanded(
          // flex: 0,
          child: new TimerText(dependencies: dependencies),
        ),
        _buildLapTimes(),
        new Expanded(
          // flex: 0,
          child: new Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildFloatingButton(
                    dependencies.stopwatch.isRunning ? "lap" : "reset",
                    leftButtonPressed),
                buildFloatingButton(
                    dependencies.stopwatch.isRunning ? "stop" : "start",
                    rightButtonPressed),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TimerText extends StatefulWidget {
  TimerText({this.dependencies});

  final Dependencies dependencies;

  TimerTextState createState() =>
      new TimerTextState(dependencies: dependencies);
}

class TimerTextState extends State<TimerText> {
  TimerTextState({this.dependencies});

  final Dependencies dependencies;
  int milliseconds;
  Timer timer;

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  @override
  void initState() {
    timer = new Timer.periodic(
        new Duration(milliseconds: dependencies.timerMillisecondsRefreshRate),
        callback);
    super.initState();
  }

  void callback(Timer timer) {
    if (milliseconds != dependencies.stopwatch.elapsedMilliseconds) {
      milliseconds = dependencies.stopwatch.elapsedMilliseconds;
      final int hundreds = (milliseconds / 10).truncate();
      final int seconds = (hundreds / 100).truncate();
      final int minutes = (seconds / 60).truncate();
      final ElapsedTime elapsedTime = new ElapsedTime(
        hundreds: hundreds,
        seconds: seconds,
        minutes: minutes,
      );
      for (final listener in dependencies.timerListeners) {
        listener(elapsedTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new RepaintBoundary(
          child: new SizedBox(
            height: 90.0,
            child: new MinutesAndSeconds(dependencies: dependencies),
          ),
        ),
        new RepaintBoundary(
          child: new SizedBox(
            // this number too.
            height: 90.0,
            child: new Hundreds(dependencies: dependencies),
          ),
        ),
      ],
    );
  }
}

class MinutesAndSeconds extends StatefulWidget {
  MinutesAndSeconds({this.dependencies});

  final Dependencies dependencies;

  MinutesAndSecondsState createState() =>
      new MinutesAndSecondsState(dependencies: dependencies);
}

class MinutesAndSecondsState extends State<MinutesAndSeconds> {
  MinutesAndSecondsState({this.dependencies});

  final Dependencies dependencies;
  int minutes = 0;
  int seconds = 0;

  @override
  void initState() {
    dependencies.timerListeners.add(onTick);
    super.initState();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.minutes != minutes || elapsed.seconds != seconds) {
      setState(() {
        minutes = elapsed.minutes;
        seconds = elapsed.seconds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return new Text('$minutesStr:$secondsStr.', style: dependencies.textStyle);
  }
}

class Hundreds extends StatefulWidget {
  Hundreds({this.dependencies});

  final Dependencies dependencies;

  HundredsState createState() => new HundredsState(dependencies: dependencies);
}

class HundredsState extends State<Hundreds> {
  HundredsState({this.dependencies});

  final Dependencies dependencies;
  int hundreds = 0;

  @override
  void initState() {
    dependencies.timerListeners.add(onTick);
    super.initState();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.hundreds != hundreds) {
      setState(() {
        hundreds = elapsed.hundreds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');
    return new Text(hundredsStr, style: dependencies.textStyle);
  }
}
