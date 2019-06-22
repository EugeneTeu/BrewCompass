import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';


abstract class BaseAuth { 
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password, String _displayName);
  Future<String> currentUser(); 
  Future<FirebaseUser> getUser();
  Future<void> signOut();
}


class Auth implements BaseAuth {
  //just to reduce wrting FirebaseAuth.instance multiple times
  final _instance = FirebaseAuth.instance;


  Future<String> signInWithEmailAndPassword(String email, String password) async {
    FirebaseUser user = await _instance.signInWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

  Future<String> createUserWithEmailAndPassword(String email, String password , String _displayName) async {

    FirebaseUser user = await _instance.createUserWithEmailAndPassword(email: email, password: password);
    UserUpdateInfo updateUser = UserUpdateInfo();
    updateUser.displayName = _displayName;
    user.updateProfile(updateUser);
    //DocumentReference ref = Firestore.instance.collection('users').document(user.uid);
    //ref.setData({'email': user.email});
    return user.uid;
  }
  //check what auth status is with fire base
  Future<String> currentUser() async {
    try{ FirebaseUser user = await _instance.currentUser();
    return user.uid;
    } catch(e) {
      
    }
  }

  Future<FirebaseUser> getUser() async {
    return await _instance.currentUser();
  }

  Future<void> signOut() async {
    return _instance.signOut();
  }
}