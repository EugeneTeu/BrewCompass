import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';


abstract class BaseAuth { 
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<String> currentUser(); 
  Future<void> signOut();
}


class Auth implements BaseAuth {
  //just to reduce wrting FirebaseAuth.instance multiple times
  final _instance = FirebaseAuth.instance;


  Future<String> signInWithEmailAndPassword(String email, String password) async {
    FirebaseUser user = await _instance.signInWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

  Future<String> createUserWithEmailAndPassword(String email, String password) async {
   FirebaseUser user = await _instance.createUserWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }
  //check what auth status is with fire base
  Future<String> currentUser() async {
    FirebaseUser user = await _instance.currentUser();
    return user.uid;
  }

  Future<void> signOut() async {
    return _instance.signOut();
  }
}