import 'package:cloud_firestore/cloud_firestore.dart';
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

class _Profile extends State<Profile>{
  String name = "displayname";
  String numberOfBrews = "loading..";
  String title;
  String userId;
  FirebaseUser currentUser;

  File _image ;
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
    NetworkImage userImage;
    if(currentUser.photoUrl != null) {
     userImage = NetworkImage(currentUser.photoUrl);
    }
    
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: <Widget>[
        Image(
          image: new AssetImage("assets/profilePage.jpg"),
          fit: BoxFit.fitHeight,
          color: Colors.black45,
          colorBlendMode: BlendMode.darken,
        ),
        Column(
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => _editProfileImage(context, userImage),
                          child: Container(
                              height: 120.0,
                              width: 120.0,
                              /*decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(62.5),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: currentUser.photoUrl != null ?
                                          userImage : _stockImage ))
                                          */
                                          child: CircleAvatar(backgroundImage:  currentUser.photoUrl != null ?
                                          userImage : _stockImage ,),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            name,
                            style: Styles.profileStyle,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              _showNumOfBrews(),
                              Text(
                                'BREWS',
                                style: Styles.profileStyle,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
                child: PastBrews(
              onRefresh: () => _refreshCounts(),
            )),
          ],
        ),
      ]),
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
        style: Styles.profileStyle,
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
                  width: MediaQuery.of(context).size.width/4,
                  child: Image(
                    image: userImage != null ? userImage : _stockImage ,
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
                      color: Colors.brown[300],
                      child: Text("Upload new picture"),
                      onPressed: () async {
                        await getImage();
                        var url = await auth.uploadProfilePic(_image);
                        UserUpdateInfo updateUser = UserUpdateInfo();
                        updateUser.photoUrl = url;
                        currentUser.updateProfile(updateUser);
                        //print("uploaded successfully");
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
