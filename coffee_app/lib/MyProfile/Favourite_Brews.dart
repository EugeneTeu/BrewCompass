import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FavouriteBrews extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FavouriteBrewsState();
  }
}

class _FavouriteBrewsState extends State<FavouriteBrews> {

   List<DocumentSnapshot> queryResults = [];
   DocumentSnapshot likedRecipes;

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
      stream: Firestore.instance.collection("users").document(this.userId).snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Text("no date in database");
        } else {
          return _buildList(context, snapshot.data);
          
                  }
                },
              );
            }
          
            Widget _buildList(BuildContext context, likeArray) {
              

            }
}
