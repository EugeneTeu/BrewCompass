import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/MyProfile/Favourite_Brews.dart';
import 'package:coffee_app/MyProfile/Journal_entry.dart';
import 'package:coffee_app/MyProfile/Recipe.dart';
import 'package:coffee_app/MyProfile/add_entry.dart';
import 'package:coffee_app/auth_provider.dart';
import 'package:coffee_app/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:open_iconic_flutter/open_iconic_flutter.dart';
import 'package:uuid/uuid.dart';

class PastBrews extends StatefulWidget {
  PastBrews({this.onRefresh});

  final VoidCallback onRefresh;

  @override
  State<StatefulWidget> createState() => _PastBrewsState();
}

class _PastBrewsState extends State<PastBrews> {
  Recipe documentToDelete;
  String userId;
  Uuid uuid = new Uuid();

  bool showPastBrew = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _user();
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

  //takes out the data from the stream
  Widget _buildPastBrews(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("testRecipesv4")
          .where('userId', isEqualTo: userId)
          .snapshots(),
      // stream: Firestore.instance.collection("testRecipes").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.black,
              )),
            ],
          );
        }
        return _buildPastBrewsList(context, snapshot.data.documents);
      },
    );
  }

  // List<String> ls = ["1", "2", "3", "4", "5", "6"];

  // void _swapItems(int a, int b) {
  //   String temp;
  //   temp = ls[a];
  //   ls[a] = ls[b];
  //   ls[b] = temp;
  // }

  // Widget _buildPastBrewsList(
  //     BuildContext context, List<DocumentSnapshot> snapshot) {
  //   return ReorderableListView(
  //     // children: ls.map((item) => ListTile(
  //     //   title: Text(item.toString()),
  //     //   key: ValueKey(item),
  //     // )).toList(),
  //     children: <Widget>[
  //       for (final item in ls)
  //         ListTile(
  //           title: Text(item),
  //           key: ValueKey(item)
  //         ),
  //     ],
  //     onReorder: (oldIndex, newIndex) {
  //       setState(() {
  //         _swapItems(oldIndex, newIndex);
  //       });
  //     },
  //   );
  // }

  //returns the list view
  Widget _buildPastBrewsList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    if (snapshot.length == 0) {
      return RefreshIndicator(
        onRefresh: widget.onRefresh,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                height: 80.0,
              ),
              Center(
                  child: Text(
                      "Your brew journal is currently empty! Start Brewing!")),
              SizedBox(
                height: 80.0,
              ),
              Center(child: Text("Start logging now!")),
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
              ),
            ],
          ),
        ),
      );
    } else {
      return RefreshIndicator(
        onRefresh: widget.onRefresh,
        child: ListView.builder(
          physics: (Platform.isAndroid)
              ? ClampingScrollPhysics()
              : AlwaysScrollableScrollPhysics(),
          // physics: ClampingScrollPhysics(),
          addAutomaticKeepAlives: true,
          itemBuilder: (BuildContext context, int index) {
            return _buildEachItem(
                context, snapshot[index], index, snapshot.length);
          },
          itemCount: snapshot.length,
        ),
      );
    }
  }

  //actually build the listtile
  Widget _buildEachItem(
      BuildContext context, DocumentSnapshot data, int index, int length) {
    final last = index + 1 == length;
    final currentEntry = Recipe.fromSnapshot(data);
    return Padding(
      //add custom padding to last entry to accomdate floating action button
      padding: !last
          ? EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0)
          : EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 120),
      child: Dismissible(
        background: Container(
          color: Colors.red,
        ),
        //unique key
        key: Key(uuid.v4()),
        onDismissed: (direction) async {
          await Firestore.instance
              .collection("testRecipesv4")
              .document(data.documentID)
              .get()
              .then((data) {
            this.documentToDelete = Recipe.fromSnapshot(data);
          });
          try {
            setState(() {
              Firestore.instance
                  .collection("testRecipesv4")
                  .document(data.documentID)
                  .delete()
                  .catchError((e) {
                print(e);
              });
            });
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("swipe down to refresh page"),
              duration: Duration(seconds: 20),
              behavior: SnackBarBehavior.fixed,
              action: SnackBarAction(
                label: "Undo",
                onPressed: () {
                  Firestore.instance.collection("testRecipesv4").add({
                    'displayName': documentToDelete.displayName,
                    'isShared': documentToDelete.isShared,
                    'date': documentToDelete.date,
                    'beanName': documentToDelete.beanName,
                    'brewer': documentToDelete.brewer,
                    'steps': documentToDelete.steps,
                    'tastingNotes': documentToDelete.tastingNotes,
                    'userId': documentToDelete.userId,
                    'userPhotoUrl': documentToDelete.userPhotoUrl,
                  });
                },
              ),
            ));
          } catch (e) {
            print("danggity");
          }
        },
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
                                JournalEntry(currentEntry, data)));
                  },
                ),
              )),
        ),
      ),
    );
  }

  void _showLiked(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            content: Text("You have switched to your liked recipes!"),
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

  void _showPersonal(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            content: Text("You have switched to your own recipes!"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(50),
            ),
          ),
          backgroundColor: Colors.white,
          /*leading: IconButton(
            icon: Icon(
              Icons.sort,
              color: Colors.black,
            ),
            onPressed: () {
              print("future filter button");
            },
          ),*/
          centerTitle: true,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        backgroundColor: Theme.of(context).primaryColor,
                        content: Text(
                          "swipe down to refresh page",
                          style: Styles.profileInfoStyle,
                        ),
                        duration: Duration(milliseconds: 800),
                        behavior: SnackBarBehavior.fixed,
                      ));
                    },
                    child: showPastBrew
                        ? Text("Journal", style: Styles.subAppBarText)
                        : Text("Liked Recipes", style: Styles.subAppBarText)),
                SizedBox(
                  width: 10.0,
                ),
                IconButton(
                  icon: Icon(
                    OpenIconicIcons.book,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    if (showPastBrew) {
                      _showLiked(context);
                    } else {
                      _showPersonal(context);
                    }
                    setState(() {
                      showPastBrew = !showPastBrew;
                    });
                    
                   

                  },
                ),
              ]),
        ),
      ),
      body: Container(
        color: Colors.white, 
        child: showPastBrew ? _buildPastBrews(context): FavouriteBrews()),
        floatingActionButton: (Platform.isAndroid)
          ? FloatingActionButton.extended(
              heroTag: null,
              icon: Icon(Icons.add),
              label: Text("New Entry"),
              onPressed: () {
                //var dummyData = {'beanName': 'black', 'brewer': 'KW'};
                //Firestore.instance.collection('v3').add(dummyData);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => AddNewEntry()));
              },
            )
          : CupertinoButton(
              color: Colors.brown[500],
              minSize: 25.0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Add Entry"),
                  SizedBox(
                    width: 5.0,
                  ),
                  Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ],
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => AddNewEntry()));
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
