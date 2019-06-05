import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'auth.dart';
import 'root.dart';
import 'styles.dart';

class LoginPage extends StatefulWidget {
  //need to pass in an instance of this abstract class BaseAuth
  LoginPage({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

enum FormType {
  login,
  register,
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  FormType _formType = FormType.login;

  bool validateAndSave() {
    final form = _formKey.currentState;
    form.save();
    if (form.validate()) {
      print("$_email, $_password");
      return true;
    } else {
      print("invalid form");
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          String userId =
              await widget.auth.signInWithEmailAndPassword(_email, _password);
          print("signed in $userId");
        } else {
          String userId = await widget.auth
              .createUserWithEmailAndPassword(_email, _password);
          print("registered");
        }
        widget.onSignedIn();
      } catch (e) {
        print(e);
        print("error signing in");
      }
    }
  }

  //register user by switching form type
  void moveToRegister() {
    _formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    _formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image(
            image: new AssetImage("assets/login_background.jpg"),
            fit: BoxFit.fitHeight,
            color: Colors.black87,
            colorBlendMode: BlendMode.darken,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        "BrewCompass",
                        style: TextStyle(
                            fontFamily: "Playfair",
                            fontSize: 25.0,
                            color: Colors.white,
                            fontStyle: FontStyle.italic),
                      ))
                ],
              ),
              Container(
                padding: EdgeInsets.all(40.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: buildInputs() + buildSubmitButtons(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> buildInputs() {
    return [
      TextFormField(
        style: Styles.loginText,
        decoration: new InputDecoration(
            hintText: "Enter Email/Username", hintStyle: Styles.loginText),
        keyboardType: TextInputType.text,
        validator: (value) => value.isEmpty ? "email cant be empty" : null,
        onSaved: (value) => _email = value,
      ),
      Divider(),
      TextFormField(
        style: Styles.loginText,
        decoration: new InputDecoration(
            hintText: "Enter password", hintStyle: Styles.loginText),
        keyboardType: TextInputType.text,
        obscureText: true,
        validator: (value) => value.isEmpty ? "password cant be empty" : null,
        onSaved: (value) => _password = value,
      ),
    ];
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        MaterialButton(
          color: Colors.brown[400],
          child: Text("Login"),
          onPressed: () => validateAndSubmit(),
        ),
        new MaterialButton(
          color: Colors.brown[400],
          child: Text("Create account"),
          onPressed: () => moveToRegister(),
        )
      ];
    } else {
      return [
        MaterialButton(
          color: Colors.brown[400],
          child: Text("create an account"),
          onPressed: () => validateAndSubmit(),
        ),
        Divider(),
        Divider(),
        new MaterialButton(
          color: Colors.brown[400],
          child: Text("Already registered?"),
          onPressed: () => moveToLogin(),
        )
      ];
    }
  }
}
