import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);

  Future<String> createUserWithEmailAndPassword(
      String email, String password, String _displayName);

  Future<String> currentUser();

  Future<FirebaseUser> getUser();

  Future<void> signOut();

  Future<String> uploadProfilePic(File file);

  Future<GoogleSignInAccount> getGoogleSignedInAccount(
      GoogleSignIn googleSignIn);

  Future<FirebaseUser> googleSignIntoFirebase(
      GoogleSignInAccount googleSignInAccount);

  FirebaseAuth get instance;

  Future<void> createLikedArray(String userUid);
}

class Auth implements BaseAuth {
  //just to reduce wrting FirebaseAuth.instance multiple times
  final _instance = FirebaseAuth.instance;

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    FirebaseUser user = await _instance.signInWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  Future<String> createUserWithEmailAndPassword(
      String email, String password, String _displayName) async {
    FirebaseUser user = await _instance.createUserWithEmailAndPassword(
        email: email, password: password);
    Firestore.instance.collection("users").document(user.uid).setData({
      "LikedRecipes": [],
    });
    print("success");
    UserUpdateInfo updateUser = UserUpdateInfo();
    updateUser.displayName = _displayName;
    user.updateProfile(updateUser);

    //DocumentReference ref = Firestore.instance.collection('users').document(user.uid);
    //ref.setData({'email': user.email});
    return user.uid;
  }

  //check what auth status is with fire base
  Future<String> currentUser() async {
    try {
      FirebaseUser user = await _instance.currentUser();
      return user.uid;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> uploadProfilePic(File file) async {
    var randomno = Random(25);
    //var imageId = randomno.nextInt(5000).toString();
    String user = "userPictures";
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child(user)
        .child("profilepics/${randomno.nextInt(5000).toString()}.jpg");
    print(ref);
    StorageUploadTask uploadTask = ref.putFile(file);
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  Future<GoogleSignInAccount> getGoogleSignedInAccount(
      GoogleSignIn googleSignIn) async {
    GoogleSignInAccount account = googleSignIn.currentUser;
    if (account == null) {
      account = await googleSignIn.signInSilently();
    }
    return account;
  }

  Future<FirebaseUser> googleSignIntoFirebase(
      GoogleSignInAccount googleSignInAccount) async {
    GoogleSignInAuthentication googleAuth =
        await googleSignInAccount.authentication;
    //print(googleAuth.accessToken);
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await _instance.signInWithCredential(credential);
  }

  Future<FirebaseUser> getUser() async {
    return await _instance.currentUser();
  }

  Future<void> signOut() async {
    return _instance.signOut();
  }

  FirebaseAuth get instance {
    return _instance;
  }

  Future<void> createLikedArray(String userUid) async{
    Firestore.instance.collection("users").document(userUid).setData({
      "LikedRecipes": [],
    });
    //print("got here");
  }
}
