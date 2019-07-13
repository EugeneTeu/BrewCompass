import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/MyProfile/Journal_entry.dart';
import 'package:coffee_app/MyProfile/Recipe.dart';
import 'package:coffee_app/MyProfile/add_entry.dart';
import 'package:coffee_app/auth_provider.dart';
import 'package:coffee_app/GlobalPage/view-Entry.dart';
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
  String userId;
  Uuid uuid = new Uuid();

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _user();
  }

  @override
  void initState() {
    super.initState();
  }

  Stream<QuerySnapshot> newStream() {
    return Firestore.instance
        .collection("testRecipesv3")
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(
                Icons.sort,
                color: Colors.black,
              ),
              onPressed: () {
                print("future filter button");
              },),
          title: Text(
            "Journal",
            style: TextStyle(color: Colors.black, ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(2.0),
            child: Container(color: Colors.brown[400], height: 2.0),
          ),
        ),
        body: _buildPastBrews(context),
        floatingActionButton: (Platform.isAndroid)
          ? FloatingActionButton.extended(
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
              child: Text("Add Entry"),
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

  //takes out the data from the stream
  Widget _buildPastBrews(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("testRecipesv3")
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
              SizedBox(height: 80.0,),
              Center(child: Text("Your brew journal is currently empty! Start Brewing!")),
              SizedBox(height: 80.0,),
              Center(child: Text("Start logging now!")),
              SizedBox(height: 80.0,),
            ],
          ),
        ),
      );
    } else {
      return RefreshIndicator(
        onRefresh: widget.onRefresh,
              child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return _buildEachItem(
                context, snapshot[index], index, snapshot.length);
          },
          itemCount: snapshot.length,
        ),
      );
    }
  }

 final snackBarDelete = SnackBar(
  content: Text("swipe down to refresh page"),
 duration: Duration(seconds: 5),
);

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
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Dismissible(
          background: Container(
            color: Colors.red,
          ),
          //unique key
          key: Key(uuid.v4()),
          onDismissed: (direction) {
            try {
              Scaffold.of(context).showSnackBar(snackBarDelete);
              setState(() {
                Firestore.instance
                    .collection("testRecipesv3")
                    .document(data.documentID)
                    .delete()
                    .catchError((e) {
                  print(e);
                });
               
              }
              );
            widget.onRefresh;
            } catch (e) {
              print("danggity");
            }
       
          },
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
                  left: BorderSide(width: 1.0, color: Colors.brown[400]),
                )),
                child: MaterialButton(
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.chevron_right,
                        color: Colors.brown[300],
                      ),
                      Text("View Entry",
                          style: TextStyle(color: Colors.brown[400])),
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

  
}
