
import 'package:flutter/material.dart';
import './styles.dart';
import './search_bar.dart';

class RecipePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RecipePageState();
}

class RecipePageState extends State<RecipePage> {
  
  TextEditingController _controller;
  FocusNode _focusNode;
  String _terms = '';

   @override
  void initState() {
    super.initState();
    _controller = TextEditingController()..addListener(_onTextChanged);
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _terms = _controller.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: 
        const BoxDecoration(
        color: Styles.scaffoldBackground,
      ),
      child: new Column(
        children: <Widget>[
         _buildSearchBox(),
          Expanded(
            child: _buildBody(),)
        ],
      ),
    );
  }

  Widget _buildBody() {
    return ListView.builder(
      padding: const EdgeInsets.all(5.0),
      itemBuilder: (context, i) {
        return _buildRow(i);
      },);
  }

   Widget _buildRow(int i) {
    return new ListTile(
      title: new Text("Coffee Recipe " + i.toString() ),
    );
  }

   Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SearchBar(
        controller: _controller,
        focusNode: _focusNode,
        
      ),
    );
  }     


}