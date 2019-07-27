import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/MyProfile/Recipe.dart';
import 'package:flutter/material.dart';
import 'package:open_iconic_flutter/open_iconic_flutter.dart';

class ViewJournalEntry extends StatelessWidget {
  ViewJournalEntry(Recipe currentEntry)
      : this.currentRecipe = currentEntry;
    

  final Recipe currentRecipe;
  

  Widget _buildSteps() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final currentNum = index + 1;
                      return ListTile(
                        leading: Text(currentNum.toString()),
                        title: Text(currentRecipe.steps[index]),
                      );
                    },
                    itemCount: currentRecipe.steps.length,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Widget shareButton = _buildShareButton();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        //remove backbutton
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text("View Entry"),
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Center(
            child: Card(
              elevation: 10.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Container(
                      child: CircleAvatar(
                        backgroundImage: currentRecipe.userPhotoUrl != null ?
                            NetworkImage(currentRecipe.userPhotoUrl) : AssetImage('assets/BrewCompass-icon-1.png'),
                      ),
                    ),
                    //Icon(OpenIconicIcons.person),
                    title:
                        Text("Recipe Brewed By " + currentRecipe.displayName),
                  ),
                  ListTile(
                    leading: Icon(OpenIconicIcons.text),
                    title: Text("Name Of Bean: " + currentRecipe.beanName),
                    subtitle: Text("Date of Entry: " + currentRecipe.date),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(OpenIconicIcons.beaker),
                    title: Text("Brewer Used"),
                    subtitle: Text(currentRecipe.brewer),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(OpenIconicIcons.task),
                    title: Text("Tasting Notes"),
                    subtitle: Text(currentRecipe.tastingNotes),
                  ),
                  Divider(),
                  Center(child: Text("Steps For This Entry")),
                  _buildSteps(),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
