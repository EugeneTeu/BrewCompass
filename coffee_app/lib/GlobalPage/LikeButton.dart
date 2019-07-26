import 'package:flutter/cupertino.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LikeButton extends StatefulWidget {
  String documentID;
  String userid;
  bool isLiked;
  Function refreshLikedRecipes;

  LikeButton.liked(this.documentID, this.userid, this.refreshLikedRecipes) {
    isLiked = true;
  }

  LikeButton.unliked(this.documentID, this.userid, this.refreshLikedRecipes) {
    isLiked = false;
  }

  @override
  State<StatefulWidget> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  DocumentSnapshot likedRecipes;

  //function to show dialog
  void _showLiked(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            content: Text("You have liked this recipe!"),
            actions: <Widget>[
              CupertinoButton(
                child: Text("Dismiss"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
  void _showUnLiked(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            content: Text("You have unliked this recipe!"),
            actions: <Widget>[
              CupertinoButton(
                child: Text("Dismiss"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _toggleLikeStatus();
        if(widget.isLiked) {
        _showLiked(context);
        } else {
          _showUnLiked(context);
        }
      },
      child: Container(
        height: 150,
        padding: EdgeInsets.only(right: 12.0),
        decoration: BoxDecoration(
            border:
                Border(right: BorderSide(width: 1.0, color: Colors.black45))),
        child: widget.isLiked
            ? Icon(Icons.star, color: Colors.black)
            : Icon(Icons.star_border, color: Colors.black),
      ),
    );
  }

  void _toggleLikeStatus() async {
    setState(() {
      widget.isLiked = !widget.isLiked;
    });
    print('clicked');

    // populating local with latest change
    QuerySnapshot docs =
        await Firestore.instance.collection('users').getDocuments();

    for (int i = 0; i < docs.documents.length; ++i) {
      if (docs.documents[i].documentID == widget.userid) {
        likedRecipes = docs.documents[i];
        //print(likedRecipes.data);
      }
    }

    List<String> likedListOfStrings =
        List<String>.from(likedRecipes.data['LikedRecipes']);

    if (widget.isLiked) {
      //add this recipe only if it is not already liked to the liked recipes
      // this checks prevents race conditions
      if (!likedListOfStrings.contains(widget.documentID)) {
        likedListOfStrings.add(widget.documentID);
      }

      print(likedListOfStrings);
    } else {
      // remove all instances of this recipe from liked recipes
      // regardless of how many instances there are (should be at most 1)
      while (likedListOfStrings.contains(widget.documentID)) {
        likedListOfStrings.remove(widget.documentID);
      }
      print(likedListOfStrings);
    }

    // Firestore.instance.collection('users').document(widget.documentID).delete();
    // Firestore.instance.collection('users').add({'LikedRecipes' : likedListOfStrings});

    Firestore.instance
        .collection('users')
        .document(widget.userid)
        .updateData({"LikedRecipes": likedListOfStrings});

    widget.refreshLikedRecipes();
  }
}
