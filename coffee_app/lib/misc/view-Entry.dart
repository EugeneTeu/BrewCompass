import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/MyProfile/Recipe.dart';
import 'package:coffee_app/MyProfile/edit-Entry.dart';
import 'package:coffee_app/misc/brew-guide.dart';
import 'package:flutter/material.dart';

import '../styles.dart';

class ViewJournalEntry extends StatelessWidget {
  final Recipe currentRecipe;
  final DocumentSnapshot data;
  ViewJournalEntry(Recipe currentEntry, DocumentSnapshot data)
      : this.currentRecipe = currentEntry,
        this.data = data;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildLabel("Date"),
            Row(
              children: <Widget>[
                
                _buildFormattedText('Date:'),
                _buildFormattedTextField('${currentRecipe.date}'),
              ],
            ),
            _buildLabel("Bean Name"),
            _buildFormattedText('${currentRecipe.beanName}'),
            _buildLabel("Brewer"),
            _buildFormattedText('${currentRecipe.brewer}'),
            _buildLabel("Taste log"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child:
                        _buildFormattedText('${currentRecipe.tastingNotes}')),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: MaterialButton(
                        color: Theme.of(context).primaryColor,
                        child: Text("Reference"),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BrewGuideChart()));
                        },
                      ),
                    )),
              ],
            ),
            Divider(),
            _buildLabel("Steps"),
            _buildSteps(),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
      child: ListTile(
        title: Text(
          "$text",
          style: Styles.entryLabelsText,
        ),
      ),
    );
  }

  Widget _buildFormattedText(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(26.0, 0, 0, 0),
      child: Text('$text'),
    );
  }

  Widget _buildFormattedTextField(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
      child: Text('$text'),
    );
  }

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
}
