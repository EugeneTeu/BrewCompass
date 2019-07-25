import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/MyProfile/Favourite_Brews.dart';
import 'package:coffee_app/MyProfile/Past_Brews.dart';
import 'package:coffee_app/MyProfile/Recipe.dart';
import 'package:coffee_app/auth_provider.dart';
import 'package:coffee_app/styles.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:image_picker_modern/image_picker_modern.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' show File, Platform;

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Profile();
  }
}

class _Profile extends State<Profile> with SingleTickerProviderStateMixin {
  AnimationController _myAnimationController;
  Animation _myAnimation;

  bool _showJournal = true;

  String name = "displayname";
  String numberOfBrews = "loading..";
  String title;
  String userId;
  FirebaseUser currentUser;

  File _image;
  AssetImage _stockImage = AssetImage('assets/BrewCompass-icon-1.png');
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _user();
    _countBrew();
  }

  //call async method once instead of continually calling _user();
  @override
  void initState() {
    super.initState();
    _myAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _myAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_myAnimationController);
    //_user();
    // _countBrew();
  }

  //code to get firebase User
  Future<FirebaseUser> _fetchUser() async {
    var auth = AuthProvider.of(context).auth;
    FirebaseUser user = await auth.getUser();
    currentUser = user;
    return user;
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
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

  void _countBrew() async {
    List result = [];
    final QuerySnapshot temp =
        await Firestore.instance.collection("testRecipesv4").getDocuments();
    List<DocumentSnapshot> list = temp.documents;
    list.forEach((data) =>
        Recipe.fromSnapshot(data).userId == userId ? result.add(data) : {});
    //print(userId);
    //print(result.length);
    setState(() {
      numberOfBrews = result.length.toString();
    });
  }

  Future<void> _refreshCounts() async {
    setState(() {
      _countBrew();
    });
  }

  Widget _buildProfilePage(BuildContext context) {
    _myAnimationController.forward();
    NetworkImage userImage;
    if (currentUser.photoUrl != null) {
      userImage = NetworkImage(currentUser.photoUrl);
    }

    return FadeTransition(
      opacity: _myAnimation,
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Stack(fit: StackFit.expand, children: <Widget>[
          /*Image(
            image: AssetImage("assets/profilePage.jpg"),
            fit: BoxFit.fitHeight,
            color: Colors.black45,
            colorBlendMode: BlendMode.darken,
          ),*/
          Column(
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    width: 15.0,
                  ),
                  Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => _editProfileImage(context, userImage),
                        child: Container(
                          height: 90.0,
                          width: 90.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).accentColor,
                              width: 1.5,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundImage: currentUser.photoUrl != null
                                ? userImage
                                : _stockImage,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      )
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        name,
                        style: Styles.profileStyle,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      _showNumOfBrews(),
                      Text(
                        'Daily Brews',
                        style: Styles.profileInfoStyle,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                ],
              ),
              SizedBox(
                height: 4.0,
              ),
              Expanded(
                  child: (_showJournal ? 
                  PastBrews(onRefresh: () => _refreshCounts()) : FavouriteBrews() ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  Widget _showNumOfBrews() {
    if (numberOfBrews == "loading..") {
      return CircularProgressIndicator(
        backgroundColor: Colors.white,
      );
    } else {
      return Text(
        numberOfBrews,
        style: Styles.profileInfoStyle,
      );
    }
  }

  Widget cancelButton(BuildContext context) {
    return FlatButton(
      color: Colors.red[400],
      child: Icon(Icons.close),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  void _editProfileImage(BuildContext context, NetworkImage userImage) {
    var auth = AuthProvider.of(context).auth;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Edit profile picture"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 4,
                  child: Image(
                    image: userImage != null ? userImage : _stockImage,
                  ),
                ),
                Divider(),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    cancelButton(context),
                    SizedBox(width: 5.0),
                    FlatButton(
                      color: Colors.brown[400],
                      child: Text("Upload new picture"),
                      onPressed: () async {
                        await getImage();
                        //print("Test");
                        var oldUrl = currentUser.photoUrl;
                        //print("Test2");
                        if (oldUrl != null) {
                          RegExp exp =
                              new RegExp(r"https://graph.facebook.com");
                          if (exp.firstMatch(oldUrl) == null) {
                            await auth.deleteOldProfilePic(oldUrl);
                          } else {
                            //print("oh No");
                          }
                          //print(oldUrl);
                          //await auth.deleteOldProfilePic(oldUrl);
                        }
                        //print("Test3");
                        var url = await auth.uploadProfilePic(_image);

                        UserUpdateInfo updateUser = UserUpdateInfo();
                        updateUser.photoUrl = url;
                        currentUser.updateProfile(updateUser);
                        //print("uploaded successfully");
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                )
              ],
            ),
          );
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
}
