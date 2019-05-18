import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabbedPage extends StatefulWidget {
  const TabbedPage({ Key key }) : super(key: key);
  @override
  TabbedPageState createState () => TabbedPageState();
}

class TabbedPageState extends State<TabbedPage> with SingleTickerProviderStateMixin {
    final List<Tab> myTabs = <Tab>[
    Tab(text: 'Caculator'),
    Tab(text: 'Stopwatch'),
  ];
  TabController _toolController;
  @override
  void initState() {
    super.initState();
    _toolController = TabController(vsync: this, length: myTabs.length);
  }

 @override
 void dispose() {
   _toolController.dispose();
   super.dispose();
 }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _toolController,
          tabs: myTabs,
        ),
      ),
      body: TabBarView(
        controller: _toolController,
        children: myTabs.map((Tab tab) {
          return Center(child: Text(tab.text));
        }).toList(),
      ),
    );
  }
}
