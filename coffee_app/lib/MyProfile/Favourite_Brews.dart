import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/GlobalPage/view-Entry.dart';
import 'package:coffee_app/MyProfile/Journal_entry.dart';
import 'package:coffee_app/MyProfile/Recipe.dart';
import 'package:coffee_app/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FavouriteBrews extends StatefulWidget {
  @override
  _FavouriteBrewsState createState() {
    return _FavouriteBrewsState();
  }
}

class _FavouriteBrewsState extends State<FavouriteBrews> {
  List<DocumentSnapshot> queryResults = [];
  

  String userId;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _user();
    _fetchQueryResults();
  }

  void _fetchQueryResults() async {
    //print("inside fetching query results");
    QuerySnapshot docs = await Firestore.instance
        .collection('testRecipesv4')
        .where('isShared', isEqualTo: true)
        .getDocuments();
    //this.setResults = HashSet.from(docs.documents);
    for (int i = 0; i < docs.documents.length; ++i) {
      setState(() {
        queryResults.add(docs.documents[i]);
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<FirebaseUser> _fetchUser() async {
    var auth = AuthProvider.of(context).auth;
    FirebaseUser user = await auth.getUser();
    return user;
  }

  void _user() async {
    // final user = await _fetchUser();
    final user = await _fetchUser();
    setState(() {
      if (user.uid != null) {
        //name = uid.displayName;
        userId = user.uid;
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection("users")
          .document(this.userId)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Text("no date in database");
        } else {
          return _buildList(context, snapshot.data);
        }
      },
    );
  }

  Widget _buildList(context, DocumentSnapshot snapshot) {
    //print(snapshot.data.values);
 
    List<dynamic> likedRecipeArrayOfArray = snapshot.data.values.toList();
    List<dynamic> likedRecipesList = [];
    
    for (int i = 0; i < likedRecipeArrayOfArray[0].length; ++i) {
      likedRecipesList.add(likedRecipeArrayOfArray[0][i]);
    }

    if (snapshot.data.length == 0) {
      return Column(
        children: <Widget>[
          Center(child: Text(
            "You have not liked any recipes!"
          ))
        ]
      );
    } else {
      return ListView.builder(
        reverse: true,
        physics: (Platform.isAndroid)
              ? ClampingScrollPhysics()
              : AlwaysScrollableScrollPhysics(),
        addAutomaticKeepAlives: true,
        itemBuilder: (BuildContext context, int index) {
          
          var currentEntry = findRecipe(likedRecipesList[index]);
          return _buildEachItem(context, currentEntry ,index, snapshot.data.length);
          
        },   
      itemCount: likedRecipesList.length,
      );
    }
 
  }

  Recipe findRecipe(String recipeId) {
    for (int i = 0; i < queryResults.length; ++i) {
      //print(queryResults[i].data);
      if (queryResults[i].documentID == recipeId) {
        return Recipe.fromSnapshot(queryResults[i]);
      }
    }
    return Recipe.dummyRecipe();
  }

  Widget _buildEachItem(BuildContext context, Recipe currentEntry, int index, int length) {
     final last = index + 1 == length;
    return Padding(
      padding: !last ? EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0) : EdgeInsets.fromLTRB(20, 15, 20, 60.0) ,
      child: Card(
            elevation: 8.0,
            child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                leading: Container(
                  height: 100.0,
                  padding: EdgeInsets.only(right: 12.0),
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(width: 1.0, color: Colors.black45))),
                  child: Icon(Icons.book, color: Theme.of(context).accentColor),
                ),
                title: Text("Bean: " + currentEntry.beanName),
                subtitle: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Brewer used: " + currentEntry.brewer),
                    Text("Brewed on " + currentEntry.date),
                  ],
                ),
                trailing: Container(
                  decoration: BoxDecoration(
                      border: Border(
                    left: BorderSide(
                        width: 1.0, color: Theme.of(context).accentColor),
                  )),
                  child: MaterialButton(
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.chevron_right,
                          color: Theme.of(context).accentColor,
                        ),
                        Text("View Entry",
                            style:
                                TextStyle(color: Theme.of(context).accentColor)),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ViewJournalEntry(currentEntry)));
                    },
                  ),
                )),
          ),
    );

  }



}
