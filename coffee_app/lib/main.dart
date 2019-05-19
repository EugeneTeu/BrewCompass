import 'package:coffee_app/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './caculator.dart';
import './Homepage.dart';
import './RecipePage.dart';
import './test_page.dart';
import './tabbedPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Coffee App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedPage = 0;
  final _pageOptions = [
    TestPage(),
    RecipePage(),
    TabbedPage(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new PreferredSize(
        preferredSize: Size.fromHeight(32.0),
        child: AppBar(
          title: Text(widget.title),
        ),
      ),
      body: _pageOptions[_selectedPage],
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            canvasColor: Colors.blueGrey,
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            textTheme: Theme.of(context)
                .textTheme
                .copyWith(caption: new TextStyle(color: Colors.yellow))),
        child: BottomNavigationBar(
            currentIndex: _selectedPage,
            onTap: (int index) {
              setState(() {
                _selectedPage = index;
              });
            },
            type: BottomNavigationBarType.shifting,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.description, ),
                title: Text('Recipes'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.build),
                title: Text('Tools'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                title: Text('My Profile'),
              )
            ]),
      ),
    );
  }
}
