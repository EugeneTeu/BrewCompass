import 'package:coffee_app/MyProfile/Recipe.dart';
import 'package:flutter/material.dart';

class JournalEntry extends StatelessWidget {
  Recipe currentRecipe;

  JournalEntry(Recipe currentEntry) : this.currentRecipe = currentEntry;

  //List<Widget> steps = currentRecipe.steps.map((steps) => Text(steps)).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("This brew"),
          leading: BackButton(
            color: Colors.black,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Divider(),
              Text(currentRecipe.beanName),
              Divider(),
              Text(currentRecipe.date),
              Divider(),
              Column(
                children:
                    currentRecipe.steps.map((steps) => Text(steps)).toList(),
              ),
            ],
          ),
        ));
  }
}
