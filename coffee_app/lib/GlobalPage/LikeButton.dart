import 'package:flutter/cupertino.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/material.dart';


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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.isLiked = !widget.isLiked;
        });
        print('clicked');
      },
      child: Container(
        height: 150,
        padding: EdgeInsets.only(right: 12.0),
        decoration: BoxDecoration(
            border: Border(
                right:
                    BorderSide(width: 1.0, color: Colors.black45))),
        child: widget.isLiked 
            ? Icon(Icons.check_box, color: Colors.black)
            : Icon(Icons.check_box_outline_blank, color: Colors.black),
      ),
    );
  }
}