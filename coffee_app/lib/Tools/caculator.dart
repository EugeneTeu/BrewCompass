import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import '../styles.dart';
import 'dart:io' show Platform;

class MyCalcPage extends StatefulWidget {
  MyCalcPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MyCalcPageState createState() => _MyCalcPageState();
}

class _MyCalcPageState extends State<MyCalcPage> {
  final TextStyle textStyle =
      const TextStyle(fontSize: 90.0, fontFamily: "Bebas Neue");
  final TextStyle _calcFont = Styles.calcFont;

  String output = "0";
  String _output = "0";
  double num1 = 0.0;
  double num2 = 0.0;
  String operand = "";

  _buttonPressed(String num) {
    if (num == "C") {
      _output = "0";
      num1 = 0.0;
      num2 = 0.0;
      operand = "";
    } else if (num == "X" || num == "/" || num == "+" || num == "-") {
      num1 = double.parse(output);
      operand = num;
      _output = "0";
    } else if (num == ".") {
      if (_output.contains(".")) {
        print('Already contains .');
        return;
      } else {
        _output = _output + num;
      }
    } else if (num == "=") {
      num2 = double.parse(output);
      if (operand == "+") {
        _output = (num1 + num2).toString();
      }
      if (operand == "-") {
        _output = (num1 - num2).toString();
      }
      if (operand == "X") {
        _output = (num1 * num2).toString();
      }
      if (operand == "/") {
        _output = (num1 / num2).toString();
      }
      num1 = 0.0;
      num2 = 0.0;
      operand = "";
    } else {
      _output = _output + num;
    }

    setState(() {
      output = double.parse(_output).toStringAsFixed(2);
    });
  }

  Widget _buildAndroidButton(String i) {
    return new RaisedButton(
      child: Text(
        i,
        style: _calcFont,
      ),
      onPressed: () => _buttonPressed(i),
      color: Colors.grey[400],
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(20)),
    );
  }

  Widget _buildIOSButton(String i) {
    return CupertinoButton(
      child: Text(
        i,
        style: _calcFont,
      ),
      onPressed: () => _buttonPressed(i),
      color: Colors.grey[400],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Container(
      child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Expanded(
              child: new Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    output,
                    style: textStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children:  <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildAndroidButton("7"),
                      _buildAndroidButton("8"),
                      _buildAndroidButton("9"),
                      _buildAndroidButton("/"),
                    ],
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildAndroidButton("4"),
                      _buildAndroidButton("5"),
                      _buildAndroidButton("6"),
                      _buildAndroidButton("X"),
                    ],
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildAndroidButton("1"),
                      _buildAndroidButton("2"),
                      _buildAndroidButton("3"),
                      _buildAndroidButton("-"),
                    ],
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildAndroidButton("."),
                      _buildAndroidButton("0"),
                      _buildAndroidButton("00"),
                      _buildAndroidButton("+"),
                    ],
                  ),
                  new Container(
                    padding: EdgeInsets.fromLTRB(10, 0.0, 10, 0.0),
                    child: new Row(
                      children: <Widget>[
                        new Expanded(flex: 3, child: _buildAndroidButton("C")),
                        new Expanded(child: _buildAndroidButton("="))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ]),
    ));
  }
}
