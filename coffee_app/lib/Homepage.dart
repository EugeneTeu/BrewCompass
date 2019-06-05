import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'auth.dart';
import 'misc/RecipePage.dart';
import 'misc/profile_page.dart';
import 'misc/test_page.dart';
import 'utilities/tabbedPage.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.auth, this.onSignedOut})
      : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState(auth,onSignedOut);
}


class _MyHomePageState extends State<MyHomePage> {


   _MyHomePageState(this._auth, this._onSignedOut);
   final BaseAuth _auth;
   final VoidCallback _onSignedOut;



   void _signOut() async {
    try {
      await _auth.signOut();
     _onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  Widget BuildTopBar(BuildContext context) => new AppBar(
    title: Row(
      children: <Widget>[
        Expanded(
          flex: 6,
          child: SizedBox(
            width: 10.0,
          ),
        ),
        Expanded(
            flex: 7,
            child: Text("BrewCompass",
                style: TextStyle(fontStyle: FontStyle.italic))),
        Expanded(
          flex: 4,
          child: SizedBox(
            width: 10.0,
          ),
        ),
      ],
    ),
    actions: <Widget>[
      new MaterialButton(
        child: Text("logout"),
        onPressed:  () { 
          _signOut();
        } ,
      )
    ],
  );

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
      appBar: BuildTopBar(context),
      body: _pageOptions[_selectedPage],
      bottomNavigationBar: new Theme(
        isMaterialAppTheme: true,
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: Colors.brown[200],
        ),
        child: BottomNavigationBar(
            selectedItemColor: Colors.white,
            selectedFontSize: 10.0,
            unselectedItemColor: Colors.black,
            unselectedFontSize: 10.0,
            iconSize: 20.0,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            currentIndex: _selectedPage,
            onTap: (int index) {
              setState(() {
                _selectedPage = index;
              });
            },
            type: BottomNavigationBarType.shifting,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                title: Text(
                  'Home',
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.description),
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
