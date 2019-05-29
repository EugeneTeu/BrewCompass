

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PageTest extends StatelessWidget {
 String word;
  PageTest(String word) {
    this.word = word;
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(body: new Text(this.word),);
  }

}