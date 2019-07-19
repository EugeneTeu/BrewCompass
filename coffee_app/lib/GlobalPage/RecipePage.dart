import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/MyProfile/Recipe.dart';
import 'package:coffee_app/GlobalPage/search_bar.dart';
import 'package:coffee_app/GlobalPage/view-Entry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class RecipePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  List<DocumentSnapshot> queryResults = [];
  List<DocumentSnapshot> tempSearchedResults = [];

  TextEditingController _controller;
  FocusNode _focusNode;
  String _terms = '';
  SortingConditions sortingCondition = SortingConditions.beanName;

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()..addListener(_onTextChanged);
    _focusNode = FocusNode();
    _fetchQueryResults();
  }

  void _fetchQueryResults() async {
    final QuerySnapshot docs = await Firestore.instance
        .collection('testRecipesv4')
        .where('isShared', isEqualTo: true)
        .getDocuments();

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
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
      child: SearchBar(
        controller: _controller,
        focusNode: _focusNode,
      ),
    );
  }

  void _changesortingConditionition() {
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
        tempSearchedResults
            .sort((a, b) => a["beanName"].compareTo(b["beanName"]));
      });
    } else {
      print("ERROR: invalid sorting condition, switch case fall through");
    }

    // always rotate the sorting condition on click
    _nextSortingCondition();

    /*
    switch (sortingCondition) {
      case SortingConditions.beanName: {
        setState(() {
          tempSearchedResults.sort((a, b) => a["beanName"].compareTo(b["beanName"]));
        });
      }
      break;

      case SortingConditions.brewer: {
        setState(() {
          tempSearchedResults.sort((a, b) => a["brewer"].compareTo(b["brewer"]));
        });
      }
      break;

      case SortingConditions.date: {
        setState(() {
          tempSearchedResults.sort((a, b) => a["beanName"].compareTo(b["beanName"]));
        });
      }
      break;   

      default: {
        print("ERROR: invalid sorting condition, switch case fall through");
      }
    }
    */
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

  @override
  Widget build(BuildContext context) {
    //super.build(context);
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image(
              image: AssetImage("assets/globalPageBackground.jpg"),
              fit: BoxFit.fitHeight,
              color: Colors.black54,
              colorBlendMode: BlendMode.darken,
            ),
            Opacity(
              opacity: 0.95,
              child: Column(
                children: <Widget>[
                  _buildSearchBox(),
                  Expanded(
                    child: tempSearchedResults.length == 0
                        ? _showLoading()
                        : ListView.builder(
                            itemCount: tempSearchedResults.length,
                            itemBuilder: (context, index) => _buildEachItem(
                                context,
                                tempSearchedResults[index],
                                index,
                                tempSearchedResults.length),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
          onPressed: () => _changesortingConditionition(),
          icon: Icon(Icons.reorder),
          label: Text(sortingCondition.toString())),
    );
  }

  Widget _buildEachItem(BuildContext context, DocumentSnapshot currentEntry,
      int index, int length) {
    //final last = index + 1 == length;
    // final currentEntry = Recipe.fromSnapshot(data);
    return Padding(
      key: ValueKey(currentEntry['id']),
      //add custom padding to last entry to accomdate floating action button
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),

      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1.0, color: Colors.black),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: GestureDetector(
                onTap: () {
                  _showLiked(context);
                },
                child: Container(
                  padding: EdgeInsets.only(right: 12.0),
                  decoration: BoxDecoration(
                      border: Border(
                          right:
                              BorderSide(width: 1.0, color: Colors.black45))),
                  child: Icon(Icons.star_border, color: Colors.black),
                ),
              ),
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
                          color: Colors.brown[400],
                        ),
                        Text(
                          "view",
                          style: TextStyle(color: Colors.brown[400]),
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
              ))),
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
}
/*
  //actually build the listtile
  Widget _buildEachItem(
      BuildContext context, DocumentSnapshot data, int index, int length) {
    final last = index + 1 == length;
    final currentEntry = Recipe.fromSnapshot(data);
    return Padding(
      key: ValueKey(currentEntry.id),
      //add custom padding to last entry to accomdate floating action button
      padding: !last
          ? EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0)
          : EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 70),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right:
                          new BorderSide(width: 1.0, color: Colors.black45))),
              child: Icon(Icons.book, color: Colors.black),
            ),
            title: Text("Bean: " + currentEntry.beanName),
            subtitle: Text(currentEntry.brewer),
            trailing: Container(
              child: IconButton(
                icon: Icon(Icons.library_books),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ViewJournalEntry(currentEntry, data)));
                },
              ),
            )),
      ),
    );
  }
  */

/* 
// previous hard coded global repo recipe page.
import 'package:flutter/material.dart';
import '../styles.dart';
import './search_bar.dart';

class RecipePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RecipePageState();
}

class RecipePageState extends State<RecipePage> {
  
  TextEditingController _controller;
  FocusNode _focusNode;
  String _terms = '';

   @override
  void initState() {
    super.initState();
    _controller = TextEditingController()..addListener(_onTextChanged);
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _terms = _controller.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: 
        const BoxDecoration(
        color: Styles.scaffoldBackground,
      ),
      child: new Column(
        children: <Widget>[
      
          Expanded(
            child: _buildBody(),)
        ],
      ),
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

   Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SearchBar(
        controller: _controller,
        focusNode: _focusNode,
        
      ),
    );
  }     


}
*/

enum SortingConditions { beanName, brewer, date }
