import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/MyProfile/Main_profile_page_pastBrewTab.dart';
import 'package:coffee_app/MyProfile/Recipe.dart';
import 'package:coffee_app/MyProfile/add_entry.dart';
import 'package:coffee_app/auth.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Profile extends StatefulWidget {
  Profile(this.auth);
  final BaseAuth auth;
  @override
  State<StatefulWidget> createState() {
    return _Profile();
  }
}

class _Profile extends State<Profile> {
  String name = "displayname";
  String title;
  String numberOfBrews = "loading..";
  String userId;

  //code to get firebase User
  Future<FirebaseUser> _fetchUser() async {
    FirebaseUser user = await widget.auth.getUser();
    return user;
  }

  //input here, might not need this method
  void _user() async {
    final user = await _fetchUser();
    
    setState(() {
      if (user.displayName != null) {
        name = user.displayName;
        userId = user.uid;
      } else {}
    });  
  }

  //call async method once instead of continually calling _user();
  @override
  void initState() {
    super.initState();
    _user();
    _countBrew();
  }

  void _countBrew() async {
    List result = [];
    final QuerySnapshot temp = await Firestore.instance.collection("testRecipesv3").getDocuments();
    List<DocumentSnapshot> list = temp.documents;
    list.forEach( (data) => Recipe.fromSnapshot(data).userId == userId  ? result.add(data) : {}  );
    //print(userId);
    //print(result.length);
    setState(() {
      numberOfBrews = result.length.toString();
    });
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchUser(),
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.hasData && name != null) {
          //_user();
          return _buildProfilePage(context);
        } else {
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                CircularProgressIndicator(),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildProfilePage(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 25.0,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 80.0,
                width: 80.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(62.5),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/BrewCompass-icon-1.png'))),
              ),
              SizedBox(height: 25.0),
              Text(
                name,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.0),
              Text(
                'Singapore',
                style: TextStyle(fontFamily: 'Montserrat', color: Colors.grey),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          numberOfBrews,
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'BREWS',
                          style: TextStyle(
                              fontFamily: 'Montserrat', color: Colors.grey),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(child: PastBrewTab(auth: widget.auth)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text("New Entry"),
        onPressed: () {
          //var dummyData = {'beanName': 'black', 'brewer': 'KW'};
          //Firestore.instance.collection('v3').add(dummyData);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AddNewEntry(widget.auth)));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

/*
   Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '21',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'JOURNAL LOG',
                          style: TextStyle(
                              fontFamily: 'Montserrat', color: Colors.grey),
                        )
                      ],
                    )
*/
