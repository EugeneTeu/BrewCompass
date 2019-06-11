import 'package:coffee_app/MyProfile/Main_profile_page_pastBrewTab.dart';
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
  String name ="displayname";
  String title;


/*code to get firebase User*/
  Future<FirebaseUser> _fetchUser() async {
    FirebaseUser user = await widget.auth.getUser();
    return user;
  }

  /*input here, might not need this method */
  void _user() async {
    final uid = await _fetchUser();
    setState(() {
      name = uid.displayName;
    });
    //print(uid);
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchUser(),
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.hasData) {
          _user();
          return _buildProfilePage(context);
        } else {
          return Scaffold(
            body: LinearProgressIndicator(),
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
                padding: EdgeInsets.all(30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '31',
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
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: PastBrewTab()),
        ],
      ),
    );
  }

}

/* 
@override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: new BoxDecoration(
                border: new Border.all(
                  color: Colors.black45,
                  style: BorderStyle.solid,
                  width: 2.0,
                )
              ),
              padding: EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Image(
                    image: AssetImage('assets/coffeeCompass.png'),
                    fit: BoxFit.fitHeight,
                  ),
                  new Text("Username"),
                  new SizedBox(
                    height: 10.0,
                    width: 40.0,
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 30.0,),
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.white,
              child: new TabbedPageMain(),
            ),
          )
        ],
      ),
    );
  }*/
