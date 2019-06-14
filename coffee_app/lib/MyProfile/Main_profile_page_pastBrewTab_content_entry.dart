import 'package:coffee_app/MyProfile/Recipe.dart';
import 'package:flutter/material.dart';

class JournalEntry extends StatelessWidget {
  
  final Recipe currentRecipe;

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
              // Divider(),
              Text(currentRecipe.beanName != null ? currentRecipe.beanName : 'bean name here'),
              Divider(),
              Text(currentRecipe.brewer != null ? currentRecipe.brewer : 'brewer here'),
              Divider(),
              Text(currentRecipe.tastingNotes != null ? 
                  currentRecipe.tastingNotes : 'tasting notes here'),
              Divider(),
              Text(currentRecipe.date != null ? currentRecipe.date : 'Date here'),
              Divider(),
              Column(
                children:
                    currentRecipe.steps != null ? currentRecipe.steps.map((steps) => Text(steps)).toList() : [Text("steps here")],
              ),
            ],
          ),
        ));
  }
}
