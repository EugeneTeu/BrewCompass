import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coffee_app/auth.dart';
import 'package:coffee_app/ProfilePageTabs/Recipe.dart';
import 'journal_entry.dart';

class Journal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _JournalState();
  }
}

class _JournalState extends State<Journal> {
  /*implement this using stream builder first. 
  to implement this via account version, we must find a way to access the 
  instance of the firebase user when i call this statelesswidget, prob 
  using future builder?
  Would be something like FutureBuilder( future: (where i await theuser id) 
  then we will pull the journals based on this user uid. 
  TODO: figure out how to access current instance of user based on account
  */
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildJournal(context),
    );
  }

  //takes out the data from the stream
  Widget _buildJournal(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("testRecipes").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        }
        return _buildJournalList(context, snapshot.data.documents);
      },
    );
  }

  //returns the list view
  Widget _buildJournalList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: EdgeInsets.only(top: 10.0),
      children: snapshot.map((data) => _buildEachItem(context, data)).toList(),
    );
  }

  //actually build the listtile
  Widget _buildEachItem(BuildContext context, DocumentSnapshot data) {
    final currentEntry = Recipe.fromSnapshot(data);

    return Padding(
      key: ValueKey(currentEntry.id),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
            title: Text("Bean: " + currentEntry.beanName),
            //subtitle: Text(currentEntry.date),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                print("future edit button");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => JournalEntry(currentEntry)));
              },
            )),
      ),
    );
  }
}
