import 'package:coffee_app/auth.dart';
import 'package:coffee_app/misc/brew-guide.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class TestPage extends StatefulWidget {
  TestPage(this.auth);
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => TestPageState();
}

class TestPageState extends State<TestPage> {
  String temp = "temp";

  //code to get firebase User
  Future<FirebaseUser> _fetchUser() async {
    FirebaseUser user = await widget.auth.getUser();
    return user;
  }

  //input here, might not need this method
  void _user() async {
    final uid = await _fetchUser();
    setState(() {
      if (uid.displayName != null) {
        temp = uid.displayName;
      } else {}
    });
  }

  //call async method once instead of continually calling _user();
  @override
  void initState() {
    super.initState();
    _user();
  }

  @override
  Widget build(BuildContext context) {
    //_user();
    return FutureBuilder(
      future: _fetchUser(),
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.hasData) {
          return _buildPage(context);
        } else {
          return _buildLoading(context);
        }
      },
    );
  }

  Widget _buildPage(BuildContext context) {
    //_user();
    return new Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(temp),
            MaterialButton(
              color: Theme.of(context).primaryColor,
              child: Text("Brewing Compass"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BrewGuideChart()));
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return new Scaffold(
      body: LinearProgressIndicator(),
    );
  }
}

