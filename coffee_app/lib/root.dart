
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'auth.dart';
import 'Homepage.dart';
import 'login_page.dart';


class RootPage extends StatefulWidget {

  RootPage({this.auth});
  final BaseAuth auth;
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

  //each time the stateful widget is created 
  @override
  void initState() {
    super.initState();
    //initState not async, cannot use await here
    widget.auth.currentUser().then((userId) {
      setState(() {
        _authStatus = userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    } ) ;
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
        auth : widget.auth,
        onSignedIn: _signedIn,);
    } else if (_authStatus == AuthStatus.signedIn) {
      return new MyHomePage(
        auth: widget.auth,
        onSignedOut: _signedOut,
      );
    }
    else {

    }

  } 

}