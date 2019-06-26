
import 'package:coffee_app/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'auth.dart';
import 'Homepage.dart';
import 'login_page.dart';


class RootPage extends StatefulWidget {

  
  @override
  State<StatefulWidget> createState() {
    return RootPageState();
  }

}

enum AuthStatus {
  notSignedIn,
  signedIn,
}

class RootPageState extends State<RootPage> {

  //initial
  AuthStatus _authStatus = AuthStatus.notSignedIn;

  @override
  void didChangeDependencies() {
    //init state for Auth
    //not ok to call object from init state
    super.didChangeDependencies();
    var auth = AuthProvider.of(context).auth;
    auth.currentUser().then((userId) {
      setState(() {
        _authStatus = userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    } ) ;
  }

  //each time the stateful widget is created 
  @override
  void initState() {
    super.initState();
  }

  void _signedIn() {
    setState(() {
      _authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      _authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_authStatus == AuthStatus.notSignedIn) {
      return new LoginPage(    
        onSignedIn: _signedIn,);
    } else if (_authStatus == AuthStatus.signedIn) {
      return new MyHomePage(
        onSignedOut: _signedOut,
      );
    }
    else {

    }
  } 
}