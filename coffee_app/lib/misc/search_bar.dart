import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../styles.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    @required this.controller,
    @required this.focusNode,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Styles.searchBackground,
         borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(padding: const EdgeInsets.symmetric(
        horizontal: 4, 
        vertical: 8,
        ),
        child: Row(
          children: [
            const Icon(Icons.search,
            ),
            Expanded(
              child: TextField(controller: controller,
              focusNode: focusNode, 
              style: Styles.searchText, 
              cursorColor: Styles.searchCursorColor,
              ),
            ),
            GestureDetector(
              onTap: controller.clear,
              child: const Icon(Icons.add_circle,
              color: Styles.searchIconColor,
              ),
            ),
          ],
        )
        ),
    );   
  }
}