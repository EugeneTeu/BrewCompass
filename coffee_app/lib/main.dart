import 'package:coffee_app/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './RecipePage.dart';
import './test_page.dart';
import './tabbedPage.dart';
import 'splashScreen.dart';

void main() {
   SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  
  return runApp(
    new MaterialApp(
      home: new SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/HomeScreen' : (BuildContext context) => new MyApp(),
      }
      )
    
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        accentColor: Colors.blueGrey[200],
        primaryColor: Colors.brown[200],
        brightness: Brightness.light,
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
        preferredSize: Size.fromHeight(20.0),
        child: AppBar(
          
         
        ),
      ),
      body: _pageOptions[_selectedPage],
      bottomNavigationBar: new Theme(
        isMaterialAppTheme: true,
        data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            canvasColor: Colors.brown[200],  
        ),
        child: BottomNavigationBar(
            
            selectedItemColor: Colors.white,
            selectedFontSize: 17.0,
            unselectedItemColor: Colors.black,
            unselectedFontSize: 12.0,
            iconSize: 23.0,
            showUnselectedLabels: true,
            currentIndex: _selectedPage,
            onTap: (int index) {
              setState(() {
                _selectedPage = index;
              });
            },
            type: BottomNavigationBarType.shifting,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home, ),
                title: Text('Home', ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.description ),
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
