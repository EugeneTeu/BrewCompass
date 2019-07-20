import 'package:coffee_app/MyProfile/Main_profile_page.dart';
import 'package:coffee_app/auth_provider.dart';
import 'package:coffee_app/GlobalPage/RecipePage.dart';
import 'package:coffee_app/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:coffee_app/Tools/tabbedPage.dart';
import 'package:open_iconic_flutter/open_iconic_flutter.dart';
import 'dart:io' show Platform;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.onSignedOut}) : super(key: key);

  final VoidCallback onSignedOut;
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState(onSignedOut);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState(this._onSignedOut);

  final VoidCallback _onSignedOut;
  PageController _pageController = new PageController();
  //intialize started page
  int _selectedPage = 0;

  void _signOut(BuildContext context) async {
    try {
      var auth = AuthProvider.of(context).auth;
      await auth.signOut();
      _onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  Widget buildTopDrawer(BuildContext context) {
    return AppBar(
        leading: Drawer(
      child: ListView(children: <Widget>[
        ListTile(
          title: Text("Logout"),
        )
      ]),
    ));
  }

  //build the top bar here
  Widget buildTopBar(BuildContext context) => AppBar(
        centerTitle: true,
        title: Text("BrewCompass"),
        backgroundColor: Colors.white,
        actions: <Widget>[
          MaterialButton(
            child: Text("Logout"),
            onPressed: () {
              _signOut(context);
            },
          )
        ],
      );

  //list of main tabs here
  List<Widget> _buildPageOptions() => [
        //TestPage(_auth),
        Profile(),
        RecipePage(),
        TabbedPage(),
      ];

  //main "Frame" of the app
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(children: <Widget>[
            DrawerHeader(
              child: Stack(children: <Widget>[
                Positioned.fill(
                    child: Center(
                        child: Column(
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: BoxConstraints.loose(Size.fromHeight(70.0)),
                      child: Image(
                        image: AssetImage('assets/coffeeCompass.png'),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Text(
                      "BrewCompass",
                      style: Styles.drawerTitleText,
                    ),
                    Text(
                      "For Coffee Geeks",
                      style: Styles.drawerSubtitleText,
                    )
                  ],
                )))
              ]),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            ),
            ListTile(
              title: Text("Logout"),
              trailing: IconButton(
                icon: Icon(OpenIconicIcons.accountLogout, color: Colors.black),
                onPressed: () {
                  try {
                    _signOut(context);
                  } catch (e) {}
                },
              ),
            )
          ]),
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0.0,
            title: Text(
              "BrewCompass",
              style: Styles.mainAppBarText,
            ),
            centerTitle: true,
            actions: <Widget>[],
          ),
        ),
        body: IndexedStack(
          index: _selectedPage,
          children: _buildPageOptions(),
          //<Widget>[_buildPageOptions()[_selectedPage]]
        ),
        bottomNavigationBar: (Platform.isAndroid)
            ? BottomNavigationBar(
                elevation: 0.0,
                backgroundColor: Colors.white,
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
                      icon: Icon(OpenIconicIcons.compass),
                      title: Text('Recipes'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.build),
                      title: Text('Utilities'),
                    ),
                  ])
            : CupertinoTabBar(
                border: Border(),
                iconSize: 24.0,
                backgroundColor: Colors.white,
                //inactiveColor: Colors.black,
                activeColor: Colors.black,
                currentIndex: _selectedPage,
                onTap: (int index) {
                  setState(() {
                    _selectedPage = index;
                  });
                },
                items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.people_outline),
                      title: Text('Profile'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(OpenIconicIcons.compass),
                      title: Text('Recipes'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.build),
                      title: Text('Utilities'),
                    ),
                  ]));
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
