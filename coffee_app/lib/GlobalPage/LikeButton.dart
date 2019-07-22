import 'package:flutter/cupertino.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/material.dart';


class LikeButton extends StatefulWidget {
  String documentID;
  bool isLiked;

  LikeButton.liked(String documentID) {
    this.documentID = documentID;
    isLiked = true;
  }

  LikeButton.unliked(String documentID) {
    this.documentID = documentID;
    isLiked = false;
  }

  @override
  State<StatefulWidget> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('liked!');
      },
      child: Container(
        height: 150,
        padding: EdgeInsets.only(right: 12.0),
        decoration: BoxDecoration(
            border: Border(
                right:
                    BorderSide(width: 1.0, color: Colors.black45))),
        child: widget.isLiked 
            ? Icon(Icons.star_border, color: Colors.black)
            : Icon(Icons.stars, color: Colors.black),
      ),
    );
  }
}