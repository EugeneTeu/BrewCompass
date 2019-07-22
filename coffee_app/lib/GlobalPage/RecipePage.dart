import 'dart:io' show Platform;

import 'package:coffee_app/GlobalPage/LikeButton.dart';
import 'package:coffee_app/GlobalPage/sortingConditionsEnum.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/MyProfile/Recipe.dart';
import 'package:coffee_app/GlobalPage/search_bar.dart';
import 'package:coffee_app/GlobalPage/view-Entry.dart';
import 'package:coffee_app/styles.dart';
import 'package:coffee_app/auth_provider.dart';
import 'LikeButton.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class RecipePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  //Set<DocumentSnapshot> setResults = HashSet();
  List<DocumentSnapshot> queryResults = [];
  DocumentSnapshot likedRecipes;

  SortingConditions sortingCondition = SortingConditions.beanName;
  List<DocumentSnapshot> tempSearchedResults = [];

  TextEditingController _controller;
  FocusNode _focusNode;
  String _terms = '';

  JsonEncoder encoder = JsonEncoder.withIndent('  ');

  String localuserid;
  //DatabaseReference globalrepo;
  //var sub1,sub2,sub3;

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    // sub1.cancel();
    // sub2.cancel();
    // sub3.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()..addListener(_onTextChanged);
    _focusNode = FocusNode();
    _fetchQueryResults();
    _fetchLikedRecipes();
  }

  Future<void> refreshDb() async {
    print('refreshing db');
    QuerySnapshot newDocs = await Firestore.instance
        .collection('testRecipesv4')
        .where('isShared', isEqualTo: true)
        .getDocuments();

    setState(() {
      this.queryResults = [];
      this.tempSearchedResults = [];
      queryResults.addAll(newDocs.documents);
      tempSearchedResults.addAll(newDocs.documents);
    });
    _fetchLikedRecipes();
  }

  // TODO: figure out when to refresh this later
  void _fetchLikedRecipes() async {
    var auth = AuthProvider.of(context).auth;
    String userid = await auth.currentUser();
    localuserid = userid;

    QuerySnapshot docs = await Firestore.instance
        .collection('users')
        .getDocuments();
    
    for (int i = 0; i < docs.documents.length; ++i) {
      if (docs.documents[i].documentID == userid) {
        likedRecipes = docs.documents[i];
        print(likedRecipes.data);
        // print(encoder.convert(docs.documents[i].data));
        // print('\n');
        // print(docs.documents[i].data['LikedRecipes']);
        // print('\n');
        // print(docs.documents[i]);
        // likedRecipes = docs.documents[i].data;
      }
      // print(encoder.convert(docs.documents[i].data));
      // print(likedRecipes);
    }
  }

  void _fetchQueryResults() async {
    print("inside fetching query results");
    QuerySnapshot docs = await Firestore.instance
        .collection('testRecipesv4')
        .where('isShared', isEqualTo: true)
        .getDocuments();
    //this.setResults = HashSet.from(docs.documents);
    for (int i = 0; i < docs.documents.length; ++i) {
      setState(() {
        queryResults.add(docs.documents[i]);
        tempSearchedResults.add(docs.documents[i]);
      });
    }
  }

  void _onTextChanged() {
    setState(() {
      _terms = _controller.text;
    });

    if (_controller.text.length == 0) {
      // if search field is empty, all recipes should be displayed
      setState(() {
        tempSearchedResults = queryResults;
      });
    } else {
      setState(() {
        tempSearchedResults = [];
      });

      // change the test condition in the if block below
      // to change search functionality
      bool searchPredicate(DocumentSnapshot element) =>
          element['beanName'].toLowerCase().contains(_terms.toLowerCase()) ||
          element['brewer'].toLowerCase().contains(_terms.toLowerCase());

      // in brewer branch
      queryResults.forEach((element) {
        if (searchPredicate(element)) {
          setState(() {
            tempSearchedResults.add(element);
          });
        }
      });
    }
  }

  Widget _showLoading() {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildSearchBox() {
    return SearchBar(
      controller: _controller,
      focusNode: _focusNode,
    );
  }

  String _changeDateFormatFromDDMMYYYYToYYYYMMDD(String date) {
    // change date format from DD-MM-YYYY to YYYY-MM-DD
    // for lexicographical comparison
    String dd = date.substring(0, 2);
    String mm = date.substring(3, 5);
    String yyyy = date.substring(6, 10);
    // print("from $date to ${yyyy}${mm}${dd}");
    return "$yyyy$mm$dd";
  }

  int _compareDate(String first, String second) {
    // don't forget to comvert date format first!
    String a = _changeDateFormatFromDDMMYYYYToYYYYMMDD(first);
    String b = _changeDateFormatFromDDMMYYYYToYYYYMMDD(second);
    return a.compareTo(b);
  }

  void _changesortingConditionition() {
    // always rotate the sorting condition on click
    _nextSortingCondition();

    if (sortingCondition == SortingConditions.beanName) {
      setState(() {
        tempSearchedResults.sort((a, b) =>
            a["beanName"].toLowerCase().compareTo(b["beanName"].toLowerCase()));
      });
    } else if (sortingCondition == SortingConditions.brewer) {
      setState(() {
        tempSearchedResults.sort((a, b) =>
            a["brewer"].toLowerCase().compareTo(b["brewer"].toLowerCase()));
      });
    } else if (sortingCondition == SortingConditions.date) {
      setState(() {
        // sorts in reverse chronological order
        tempSearchedResults.sort((a, b) => _compareDate(b["date"], a["date"]));
      });
    } else {
      print("ERROR: invalid sorting condition, switch case fall through");
    }
  }

  void _nextSortingCondition() {
    if (sortingCondition == SortingConditions.beanName) {
      setState(() {
        sortingCondition = SortingConditions.brewer;
      });
    } else if (sortingCondition == SortingConditions.brewer) {
      setState(() {
        sortingCondition = SortingConditions.date;
      });
    } else if (sortingCondition == SortingConditions.date) {
      setState(() {
        sortingCondition = SortingConditions.beanName;
      });
    }
  }

  String sortingConditionEnumToString(SortingConditions cond) {
    return cond.toString().substring(18);
  }

  @override
  Widget build(BuildContext context) {
    //super.build(context);
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
            child: Column(
              children: <Widget>[
                _buildSearchBox(),
                _buildSortButton(context),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => refreshDb(),
                    child: tempSearchedResults.length == 0
                        ? _showLoading()
                        : ListView.builder(
                          // physics: (Platform.isAndroid) ? ClampingScrollPhysics : BouncingScrollPhysics(),
                          physics: ClampingScrollPhysics(),
                            itemCount: tempSearchedResults.length,
                            itemBuilder: (context, index) => _buildEachItem(
                                context,
                                tempSearchedResults[index],
                                index,
                                tempSearchedResults.length),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      /*  floatingActionButton: FloatingActionButton.extended(
          heroTag: null,
          onPressed: () => _changesortingConditionition(),
          icon: Icon(Icons.reorder),
          label: Text("sort " + sortingConditionEnumToString(sortingCondition)),
        )*/
        );
  }

  Widget _buildEachItem(BuildContext context, DocumentSnapshot currentEntry,
      int index, int length) {
    //final last = index + 1 == length;
    // final currentEntry = Recipe.fromSnapshot(data);
    return Padding(
      key: ValueKey(currentEntry['id']),
      //add custom padding to last entry to accomdate floating action button
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),

      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 10.0),
          child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              
              // -------my testing area-----------------------
              leading: _buildLikeButton(currentEntry.documentID),
              // ---------------------------------------------------------------------
              // build like button here
              // leading: GestureDetector(
              //   onTap: () {
              //     _showLiked(context);
              //   },
              //   child: Container(
              //     height: 150,
              //     padding: EdgeInsets.only(right: 12.0),
              //     decoration: BoxDecoration(
              //         border: Border(
              //             right:
              //                 BorderSide(width: 1.0, color: Colors.black45))),
              //     child: Icon(Icons.star_border, color: Colors.black),
              //   ),
              // ),
              // --------------------------------------------
              title: Text("Bean: " + currentEntry['beanName']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Brewer: " + currentEntry['brewer']),
                  Text("Brewed by: " + currentEntry['displayName']),
                  Text("Brewed on: " + currentEntry['date']),
                ],
              ),
              trailing: Container(
                decoration: BoxDecoration(
                  //borderRadius: BorderRadius.circular(10.0),
                  border: Border(
                      left: BorderSide(width: 1.0, color: Colors.black45)),
                ),
                //Border.all(width: 1.0, color: Colors.brown[300])),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    primaryColor: Colors.brown[300],
                  ),
                  child: MaterialButton(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 5.0),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.black,
                        ),
                        Text(
                          "view",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewJournalEntry(
                                  Recipe.fromSnapshot(currentEntry),
                                  currentEntry)));
                    },
                  ),
                ),
              )),
        ),
      ),
    );
  }

//function to change icon to starred
  void _showLiked(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            content: Text("You have starred this recipe!"),
            actions: <Widget>[
              CupertinoButton(
                child: Text("Dismiss"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  bool isLikedRecipe(String documentID) {
    return likedRecipes.data['LikedRecipes'].contains(documentID);
  }

  Widget _buildLikeButton(String documentID) {
    return isLikedRecipe(documentID)
        ? LikeButton.liked(documentID, localuserid)
        : LikeButton.unliked(documentID, localuserid);
  }
/*
  _onEntryAdded(Event event) {
    setState(() {
      _fetchQueryResults();
    });
  }
   _onEntryModified(Event event) {
    setState(() {
      _fetchQueryResults();
    });
  }
   _onEntryDeleted(Event event) {
    setState(() {
      _fetchQueryResults();
    });
  }*/
  Widget _buildSortButton(BuildContext context) {
    return MaterialButton(
      shape: StadiumBorder(),
      elevation: 10.0,
      color: Theme.of(context).accentColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.reorder, color: Colors.white),
          SizedBox(
            width: 5.0,
          ),
          Text(sortingConditionEnumToString(sortingCondition), style: Styles.filterButton, ),
        ],
      ),
      onPressed: () => _changesortingConditionition(),
    );
  }

}
