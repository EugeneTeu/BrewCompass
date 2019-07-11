import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../styles.dart';

class SearchBar extends StatefulWidget {
  SearchBar({
    @required this.controller,
    @required this.focusNode,
  });

  TextEditingController controller;
  FocusNode focusNode;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  void initState() {
    super.initState();
    widget.focusNode = new FocusNode();
    widget.focusNode.addListener(_onOnFocusNodeEvent);
  }

  _onOnFocusNodeEvent() {
    setState(() {
     
    });
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        //borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8.0,
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: getIcon(),
              ),
              Expanded(
                child: TextField(
                 decoration: InputDecoration(hintText: "Search for recipes from other users"),
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  style: Styles.searchText,
                  cursorColor: Styles.searchCursorColor,
                ),
              ),
              GestureDetector(
                onTap: widget.controller.clear,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: getCancelIcon(),
                ),
              ),
            ],
          )),
    );
  }

  Icon getCancelIcon() {
    if (widget.focusNode.hasFocus) {
      return const Icon(
        Icons.cancel,
        color: Styles.searchIconColor,
      );
    } else {
      return Icon(
        Icons.cancel,
        color: Colors.white70,
      );
    }
  }

  Icon getIcon() {
    if (widget.focusNode.hasFocus) {
      return Icon(Icons.search, color: Colors.grey,);
    } else {
      return const Icon(
        Icons.search,
      );
    }
  }
}
