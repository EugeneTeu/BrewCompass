import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MyCalcPage extends StatefulWidget {
  MyCalcPage({Key key, this.title}) : super(key: key);
  
  final String title;
  @override
  _MyCalcPageState createState() => _MyCalcPageState();
}

class _MyCalcPageState extends State<MyCalcPage> {
  final TextStyle _calcFont = new TextStyle(fontWeight: FontWeight.bold);
  final TextStyle _ansFont = new TextStyle(fontWeight: FontWeight.bold, fontSize: 40.0);

  String output = "0";
  String _output ="0";
  double num1 = 0.0;
  double num2 = 0.0;
  String operand = "";


  _buttonPressed(String num){

    if (num == "CLEAR") {

      _output ="0";
      num1 = 0.0;
      num2 = 0.0;
      operand = "";
    } else if (num == "X" || num == "/" || num == "+" || num == "-") {
      num1 = double.parse(output);
      operand = num;
      _output = "0";

    } else if (num == ".") {
        if ( _output.contains(".") ) {
          print('Already contains .');
          return ;
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

    setState( () {
      output = double.parse(_output).toStringAsFixed(3);
    }
    );
    
  }

  Widget _buildButton(String i) {
    return new Expanded(
              child: new OutlineButton(
                  child : Text(i,
                  style: _calcFont,),
                  onPressed: () =>  _buttonPressed(i)
                  ,
                  color: Colors.blue,
                  
                  
                ),
              );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        
        child: new Column(children: <Widget>[
          new Container(
            alignment: Alignment.centerRight,
            child: Text(
              output, style: _ansFont,
              )
          ),

          new Expanded(
            child: new Divider()
            ,),
          
          
          new Row(
            children: <Widget>[
              _buildButton("7"),
              _buildButton("8"),
              _buildButton("9"),
              _buildButton("/"),

            ],
          ),

          new Row(
            children: <Widget>[
              _buildButton("4"),
              _buildButton("5"),
              _buildButton("6"),
              _buildButton("X"),

            ],
          ),
          new Row(
            children: <Widget>[
              _buildButton("1"),
              _buildButton("2"),
              _buildButton("3"),
              _buildButton("-"),
            ],
          ),
          new Row(
            children: <Widget>[
              _buildButton("."),
              _buildButton("0"),
              _buildButton("00"),
              _buildButton("+"),
            ],
          ),
           new Row(
            children: <Widget>[
              _buildButton("CLEAR"),
              _buildButton("=")
            ],
          ),
          ]),
      )
    );
  }
}
