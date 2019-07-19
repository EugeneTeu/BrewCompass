import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../styles.dart';
import "dart:io" show Platform;

class MyConverter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyConverter();
  }
}

class _MyConverter extends State<MyConverter> {
  double _beanWeight = 0.0;
  final TextEditingController _controller = new TextEditingController();
  final TextEditingController _controllerTwo = new TextEditingController();
  FocusNode _focusNode = new FocusNode();
  FocusNode _focusNodeTwo = new FocusNode();
  final _formKey = GlobalKey<FormState>();
  String _inputBeanWeight;
  String _inputRatio;
  double _ratio = 0.0;
  double _water = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: ListView(
          children: <Widget>[
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(
                      height: 40.0,
                    ),
                    ListTile(
                      title: TextFormField(
                        controller: _controllerTwo,
                        focusNode: _focusNodeTwo,
                        style: Styles.calcFont,
                        decoration: InputDecoration(
                          hintText: "Enter Weight Of Beans",
                          hintStyle: TextStyle(fontSize: 15.0),
                        ),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        validator: (value) =>
                            value.isEmpty ? "invalid number" : null,
                        onSaved: (value) => _inputBeanWeight = value,
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    ListTile(
                      title: TextFormField(
                        controller: _controller,
                        focusNode: _focusNode,
                        style: Styles.calcFont,
                        decoration:  InputDecoration(
                            hintText: "Enter Desired Water Ratio 1 : ",
                            hintStyle: TextStyle(fontSize: 15.0)),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        validator: (value) =>
                            value.isEmpty ? "invalid number" : null,
                        onSaved: (value) => _inputRatio = value,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    // Calculate and Clear button
                    ListTile(
                      title: Text("Ratio", style: Styles.calcFont),
                      trailing: Text("$_ratio"),
                    ),
                    ListTile(
                      title: Text("Water Weight", style: Styles.calcFont),
                      trailing: Text("$_water"),
                    ),
                    ListTile(
                      title: Text("Bean Weight", style: Styles.calcFont),
                      trailing: Text("$_beanWeight"),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        (Platform.isAndroid)
                            ? MaterialButton(
                                elevation: 10.0,
                                color: Colors.red,
                                child: Text(
                                  "Clear",
                                  style: Styles.calcFont,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                                onPressed: () {
                                  //clears input field and reset results field.
                                  setState(() {
                                    _controller.clear();
                                    _controllerTwo.clear();
                                    _ratio = 0.0;
                                    _beanWeight = 0.0;
                                    _water = 0.0;
                                    _inputBeanWeight = '';
                                    _inputRatio = '';
                                  });
                                },
                              )
                            : CupertinoButton(
                                color: Colors.red,
                                child: Text(
                                  "Clear",
                                  style: Styles.calcFont,
                                ),
                                minSize: 25.0,
                                onPressed: () {
                                  //clears input field and reset results field.
                                  setState(() {
                                    _controller.clear();
                                    _controllerTwo.clear();
                                    _ratio = 0.0;
                                    _beanWeight = 0.0;
                                    _water = 0.0;
                                    _inputBeanWeight = '';
                                    _inputRatio = '';
                                  });
                                },
                              ),
                        (Platform.isAndroid)
                            ? MaterialButton(
                                child: Text(
                                  "Calculate",
                                  style: Styles.calcFont,
                                ),
                                color: Colors.grey,
                                elevation: 10.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                                onPressed: () {
                                  final form = _formKey.currentState;
                                  form.save();

                                  setState(() {
                                    _ratio = double.parse(_inputRatio);
                                    _water = double.parse(_inputBeanWeight) *
                                        double.parse(_inputRatio);
                                    _beanWeight =
                                        double.parse(_inputBeanWeight);
                                  });
                                },
                              )
                            : CupertinoButton(
                                child: Text(
                                  "Calculate",
                                  style: Styles.calcFont,
                                ),
                                color: Colors.blue,
                                minSize: 5.0,
                                onPressed: () {
                                  final form = _formKey.currentState;
                                  form.save();
                                  setState(() {
                                    _ratio = double.parse(_inputRatio);
                                    _water = double.parse(_inputBeanWeight) *
                                        double.parse(_inputRatio);
                                    _beanWeight =
                                        double.parse(_inputBeanWeight);
                                  });
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                },
                              ),
                      ],
                    ),
                    SizedBox(
                      height: 40.0,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
initial way of taking focus away from the form: 
trailing: MaterialButton(
                        child: Icon(Icons.arrow_downward),
                        onPressed: () {
                          _focusNodeTwo.unfocus();
                        },
                      ), */
