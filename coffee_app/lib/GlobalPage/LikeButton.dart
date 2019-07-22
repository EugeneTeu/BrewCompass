import 'package:flutter/cupertino.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LikeButton extends StatefulWidget {
  String documentID;
  String userid;
  bool isLiked;

  LikeButton.liked(this.documentID, this.userid) {
    isLiked = true;
  }

  LikeButton.unliked(this.documentID, this.userid) {
    isLiked = false;
  }

  @override
  State<StatefulWidget> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  DocumentSnapshot likedRecipes;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _toggleLikeStatus();
      },
      child: Container(
        height: 150,
        padding: EdgeInsets.only(right: 12.0),
        decoration: BoxDecoration(
            border:
                Border(right: BorderSide(width: 1.0, color: Colors.black45))),
        child: widget.isLiked
            ? Icon(Icons.check_box, color: Colors.black)
            : Icon(Icons.check_box_outline_blank, color: Colors.black),
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
        print(likedRecipes.data);
      }
    }

    List<String> likedListOfStrings = List<String>.from(likedRecipes.data['LikedRecipes']);
    
    if (widget.isLiked) {
      // have to add this recipe to the liked recipes
      likedListOfStrings.add(widget.documentID);
    } else {
      // remove this recipe from liked recipes
      likedListOfStrings.remove(widget.documentID);
      print(likedListOfStrings);
    }

  }
}
