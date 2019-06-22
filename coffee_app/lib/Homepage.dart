import 'package:coffee_app/MyProfile/Main_profile_page.dart';
import 'package:coffee_app/misc/RecipePage.dart';
import 'package:coffee_app/misc/test_page.dart';
import 'package:flutter/material.dart';
import 'package:coffee_app/Tools/tabbedPage.dart';
import 'package:coffee_app/auth.dart';
import 'package:coffee_app/bottom_navy_bar.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.auth, this.onSignedOut})
      : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState(auth, onSignedOut);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState(this._auth, this._onSignedOut);

  final BaseAuth _auth;
  final VoidCallback _onSignedOut;

  PageController _pageController = new PageController();

  void _signOut() async {
    try {
      await _auth.signOut();
      _onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  //build the top bar here
  Widget buildTopBar(BuildContext context) => new AppBar(
        centerTitle: true,
        title:
            Text("BrewCompass", style: TextStyle(fontStyle: FontStyle.italic)),
        backgroundColor: Colors.white,
        actions: <Widget>[
          new MaterialButton(
            child: Text("logout"),
            onPressed: () {
              _signOut();
            },
          )
        ],
      );

  //intialize started page
  int _selectedPage = 0;
  //get current user

  //list of main tabs here
  List<Widget> _buildPageOptions() => [
        //TestPage(_auth),
        Profile(_auth),
        RecipePage(),
        TabbedPage(),
        
      ];

  //main "Frame" of the app
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildTopBar(context),
      body: PageView(
          controller: _pageController,
          children: <Widget>[_buildPageOptions()[_selectedPage]]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.brown[200],
        selectedItemColor: Colors.black,
          onTap: (int index) {
            setState(() {
              _selectedPage = index;
            });
          },
          currentIndex: _selectedPage,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              title: Text('Profile'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              title: Text('Recipes'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.build),
              title: Text('Utilities'),
            ),
          ]),
    );
  }
}

//legacy code
/*
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
            items: <BottomNavigationBarItem>[
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
*/

/*
BottomNavyBar(
      backgroundColor: Colors.brown[200],
      selectedIndex: _selectedPage,
      showElevation: true,
      onItemSelected: (int index) => setState(() {
            _selectedPage = index;
            //_pageController.animateToPage(index, duration :Duration(milliseconds: 100), curve: Curves.elasticIn);
          }),
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: Icon(Icons.home,),
          title: Text('Home',),
          inactiveColor: Colors.white,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.description),
          title: Text('Recipes'),
          inactiveColor: Colors.white,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.build),
          title: Text('Tools'),
          inactiveColor: Colors.white,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.people),
          title: Text('My Profile'),
          inactiveColor: Colors.white,
        )
      ]),*/
