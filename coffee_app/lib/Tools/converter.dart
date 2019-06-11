import 'package:flutter/material.dart';

import '../styles.dart';

class MyConverter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyConverter();
  }
}

class _MyConverter extends State<MyConverter> {
  final _formKey = GlobalKey<FormState>();

  double _ratio = 0.0;
  double _beanWeight = 0.0;
  double _water = 0.0;

  String _inputBeanWeight;
  String _inputRatio;
  final TextEditingController _controller = new TextEditingController();
  FocusNode _focusNode = new FocusNode();
  final TextEditingController _controllerTwo = new TextEditingController();
  FocusNode _focusNodeTwo = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: ListView(
                  children: <Widget>[
        Container(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ListTile(
                    title: TextFormField(
                      
                      controller: _controllerTwo,
                      focusNode: _focusNodeTwo,
                      style: Styles.calcFont,
                      decoration: new InputDecoration(
                        hintText: "Enter Weight Of Beans",
                        hintStyle: new TextStyle(fontSize: 15.0),
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      validator: (value) => value.isEmpty ? "invalid number" : null,
                      onSaved: (value) => _inputBeanWeight = value ,
                    ),
                    trailing: MaterialButton(
                      child: Icon(Icons.arrow_downward),
                      onPressed: () {
                        _focusNodeTwo.unfocus();
                      },
                    ),
                  ),
                  ListTile(
                    title: TextFormField(
                      controller: _controller,
                      focusNode: _focusNode,
                      style: Styles.calcFont,
                      decoration: new InputDecoration(
                          hintText: "Enter Desired Water Ratio (1:_)",
                          hintStyle: new TextStyle(fontSize: 15.0)),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      validator: (value) => value.isEmpty ? "invalid number" : null,
                      onSaved: (value) => _inputRatio = value,
                    ),
                    trailing: MaterialButton(
                      child: Icon(
                        Icons.arrow_downward,
                      ),
                      onPressed: () {
                        _focusNode.unfocus();
                      },
                    ),
                  ),
                  // Calculate and Clear button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      MaterialButton(
                        elevation: 10.0,
                        color: Colors.red,
                        child: Text("Clear", style: Styles.calcFont,),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                            onPressed: (){
                              //clears input field and reset results field.
                              setState(() {
                                _controller.clear();
                                _controllerTwo.clear();
                                _ratio = 0.0;
                                _beanWeight = 0.0;
                                _water = 0.0;
                                _inputBeanWeight ='';
                                _inputRatio ='';
                              });
                            },

                      ),
                                      MaterialButton(
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
                            _water = double.parse(_inputBeanWeight) * double.parse(_inputRatio);
                            _beanWeight = double.parse(_inputBeanWeight);
                          });
                        },
                      ),
                    ],
                  ),
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
                ],
              ),
            ),
        ),
      ],
        ),
    );
  }
}
