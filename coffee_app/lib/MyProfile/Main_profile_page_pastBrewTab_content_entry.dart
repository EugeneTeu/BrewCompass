import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/MyProfile/Recipe.dart';
import 'package:coffee_app/MyProfile/edit-Entry.dart';
import 'package:coffee_app/misc/brew-guide.dart';
import 'package:flutter/material.dart';

import '../styles.dart';

class JournalEntry extends StatelessWidget {
  final Recipe currentRecipe;
  final DocumentSnapshot data;
  JournalEntry(Recipe currentEntry, DocumentSnapshot data)
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
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0),
          child: MaterialButton(
            child: Icon(Icons.mode_edit),
            //implement editing
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => EditEntry(data)));
            },
          ),
        ),
        title: Text("View Entry"),
        actions: <Widget>[
          MaterialButton(
            child: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildLabel("Brew Details"),
            Row(
              children: <Widget>[
                _buildFormattedText("Owner: "),
                _buildFormattedTextName(currentRecipe.displayName),
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
      floatingActionButton: FloatingActionButton.extended(
        label: Text("delete this entry"),
        backgroundColor: Colors.red,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Delete Entry"),
                  content: Text("Are you sure you like to delete this entry?"),
                  actions: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                          color: Colors.blue[200],
                          child: Icon(Icons.check_circle_outline),
                          onPressed: () {
                            Firestore.instance
                                .collection("testRecipesv3")
                                .document(data.documentID)
                                .delete()
                                .catchError((e) {
                              print(e);
                            });
                            print("deleted!");
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    )
                  ],
                );
              });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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

  Widget _buildFormattedTextName(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0, 0, 0),
      child: Text('$text'),
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

/*
// TODO: remodel this whole thing to 
// become the same as edit steps, except that there are no edit buttons
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
*/
