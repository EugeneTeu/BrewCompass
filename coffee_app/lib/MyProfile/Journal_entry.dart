import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/MyProfile/Recipe.dart';
import 'package:coffee_app/MyProfile/edit-Entry.dart';
import 'package:flutter/material.dart';
import 'package:open_iconic_flutter/open_iconic_flutter.dart';


class JournalEntry extends StatelessWidget {
  JournalEntry(Recipe currentEntry, DocumentSnapshot data)
      : this.currentRecipe = currentEntry,
        this.data = data;

  final Recipe currentRecipe;
  final DocumentSnapshot data;

  /*Widget _buildLabel(String text) {
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
  }*/

  Widget _buildSteps() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Column(
              children: <Widget>[
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final currentNum = index + 1;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        ListTile(
                          leading: Text(currentNum.toString()),
                          title: Text(currentRecipe.steps[index]),
                        ),
                        Divider()
                      ],
                    );
                  },
                  itemCount: currentRecipe.steps.length,
                )
              ],
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
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        //backgroundColor: Colors.white,
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
        title: Text("View Your Entry"),
        actions: <Widget>[
          MaterialButton(
            child: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: ListView(
        
        children: <Widget>[
          Column(
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
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Icon(OpenIconicIcons.circleX),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton(
                          color: Colors.red[400],
                          child: Icon(Icons.close
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        Divider(),
                        FlatButton(
                          color: Colors.blue[200],
                          child: Icon(Icons.check_circle_outline),
                          onPressed: () {
                            Firestore.instance
                                .collection("testRecipesv4")
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
