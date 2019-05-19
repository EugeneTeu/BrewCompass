

import 'package:flutter/material.dart';

class RecipePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RecipePageState();
}

class RecipePageState extends State<RecipePage> {
  final _recipe = <String>[
    
  ];


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: _buildBody() ,
    );
  }

  Widget _buildBody() {
    return ListView.builder(
      
      padding: const EdgeInsets.all(5.0),
      itemBuilder: (context, i) {
        return _buildRow(i);
      },);

    
  
  }

   Widget _buildRow(int i) {
    return new ListTile(
      title: new Text("Coffee Recipe " + i.toString() ),
    );
  }

}