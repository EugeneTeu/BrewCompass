import 'package:coffee_app/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {

  TestPage(this.auth);
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => TestPageState();
}



class TestPageState extends State<TestPage>  {
  String temp = "";


/*code to get firebase User*/
  Future<FirebaseUser> _fetchUser() async {
    FirebaseUser user = await widget.auth.getUser();
    return user;
  }

  /*input here, might not need this method*/
  void _user() async {
    final user = await _fetchUser();
    setState(() {
      temp = user.email;
    });
   
  }



  @override
  Widget build(BuildContext context)  {
    //_user();
    return FutureBuilder(
      future: _fetchUser(),
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          if(snapshot.hasData) {
            return _buildPage(context);
          } else {
            return _buildLoading(context);
          }
      
      },
    );
  }

  Widget _buildPage(BuildContext context) {
    _user();
    return new Scaffold(
      body: Center(child: Container(child: Text(temp),),),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return new Scaffold(
      body: LinearProgressIndicator(),
    );

  }
}
