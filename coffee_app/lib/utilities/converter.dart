import 'package:flutter/material.dart';

import '../styles.dart';

class MyConverter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyConverter();
  }
}

class _MyConverter extends State<MyConverter> {
  double _ratio = 0.0;
  double _beanWeight = 0.0;
  double _water = 0.0;
  final TextEditingController _controller = new TextEditingController();
  FocusNode _focusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(  
            child: ListTile(
              title: TextFormField(
                controller: _controller,
                focusNode: _focusNode,
                style: Styles.calcFont,
                decoration:
                    new InputDecoration(hintText: "Enter Desired Water Ratio", hintStyle: new TextStyle(fontSize: 15.0)),
                keyboardType: TextInputType.number,
                validator: (value) => value.isEmpty ? "invalid number" : null,
              ),
              trailing: MaterialButton(
                child: Icon(Icons.send, ),
                onPressed: () {
                  _focusNode.unfocus();

                },
                ),

            ),

          ),
          ListTile(
            title: Text("Ratio (1: )", style: Styles.calcFont),
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
    );
  }
}
