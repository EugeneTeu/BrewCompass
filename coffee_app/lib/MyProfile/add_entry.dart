import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/MyProfile/editSteps.dart';
import 'package:coffee_app/auth.dart';
import 'package:coffee_app/misc/brew-guide.dart';
import 'package:coffee_app/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class addNewEntry extends StatefulWidget {
  addNewEntry(this.auth);

  BaseAuth auth;
  @override
  State<StatefulWidget> createState() {
    return _addNewEntryState();
  }
}

class _addNewEntryState extends State<addNewEntry> {
  GlobalKey<FormState> _key = GlobalKey();

  //code to get firebase User
  Future<FirebaseUser> _fetchUser() async {
    FirebaseUser user = await widget.auth.getUser();
    return user;
  }

  //input here, might not need this method
  void _user() async {
    // final user = await _fetchUser();
    final user = await _fetchUser();
    setState(() {
      if (user.uid != null) {
        //name = uid.displayName;
        userId = user.uid;
      } else {}
    });
  }

  //call async method once instead of continually calling _user();
  @override
  void initState() {
    super.initState();
    _user();
  }

  //id for now is manually entered, need to enable indexing by firebase
  //edit entry flow: take in a form for inputs, push recipe object to database by calling runTransaction
  //TODO: add validator to the fields, add input type for steps variable, add dropdown menu
  int id;
  bool isShared;
  String date;
  String beanName;
  String brewer;
  List steps = ["pour 30g of water, bloom for first 30s", "stir the bloom" ,"pour 50g every 30s", "stop extraction at 3:30"];
  String tastingNotes;
  String userId = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          centerTitle: true,
          title: Text("Add new entry"),
          leading: BackButton(
            color: Colors.black,
          )),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Container(
          child: Form(
            key: _key,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 40.0),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                   _buildLabel("Enter ur Brew Details"),
                  Row(
                    //need to wrap widget in expanded here to give the child widget a size parameter
                    children: <Widget>[
                      Flexible(flex: 1, child: _buildInputFieldNum()),
                      Flexible(
                        flex: 1,
                        child: _buildInputFieldDate(),
                      ),
                    ],
                  ),
                  Divider(),
                   _buildLabel("Bean Name"),
                  _buildInputFieldBeanName(),
                  Divider(),
                   _buildLabel("Brewer"),
                  _buildInputFieldBrewer(),
                  Divider(),
                  _buildLabel("taste log"),
                  Row(
                    children: <Widget>[
                      Flexible(flex: 2, child: _buildInputFieldTastingNotes()),
                      Flexible(
                          flex: 1,
                          child: MaterialButton(
                            color: Theme.of(context).primaryColor,
                            child: Text("Reference"),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BrewGuideChart()));
                            },
                          )),
                    ],
                  ),
                  Divider(),
                  _buildLabel("Steps"),
                  _buildSteps(),
                  _buildSubmitButton(),
                  Divider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
     return Padding(
                    padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
                    child: ListTile(
                      title: Text("$text", style: Styles.entryLabelsText,),
                    ),
                  );
  }

  Widget _buildInputFieldNum() {
    return Padding(
      child: TextFormField(
        style: Styles.createEntryText,
        decoration: new InputDecoration(hintText: "Enter id"),
        keyboardType: TextInputType.number,
        validator: (value) => value.isEmpty ? "field cant be empty" : null,
        onSaved: (value) => id = int.parse(value),
      ),
      padding: EdgeInsets.all(20.0),
    );
  }

  Widget _buildInputFieldDate() {
    return Padding(
      child: TextFormField(
        style: Styles.createEntryText,
        decoration: new InputDecoration(hintText: "Enter date"),
        keyboardType: TextInputType.text,
        validator: (value) => value.isEmpty ? "field cant be empty" : null,
        onSaved: (value) => this.date = value,
      ),
      padding: EdgeInsets.all(20.0),
    );
  }

  Widget _buildInputFieldBeanName() {
    return Padding(
      child: TextFormField(
        style: Styles.createEntryText,
        decoration: new InputDecoration(hintText: "Enter Bean Name"),
        keyboardType: TextInputType.text,
        validator: (value) => value.isEmpty ? "field cant be empty" : null,
        onSaved: (value) => this.beanName = value,
      ),
      padding: EdgeInsets.all(20.0),
    );
  }

  Widget _buildInputFieldBrewer() {
    return Padding(
      child: TextFormField(
        style: Styles.createEntryText,
        decoration: new InputDecoration(hintText: "Enter brewer"),
        keyboardType: TextInputType.text,
        validator: (value) => value.isEmpty ? "field cant be empty" : null,
        onSaved: (value) => this.brewer = value,
      ),
      padding: EdgeInsets.all(20.0),
    );
  }

  Widget _buildInputFieldTastingNotes() {
    return Padding(
      child: TextFormField(
        style: Styles.createEntryText,
        decoration:
            new InputDecoration(hintText: "How did the cup taste today?"),
        keyboardType: TextInputType.text,
        validator: (value) => value.isEmpty ? "field cant be empty" : null,
        onSaved: (value) => this.tastingNotes = value,
      ),
      padding: EdgeInsets.all(20.0),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: MaterialButton(
          color: Colors.brown[400],
          child: Text("Create Entry"),
          onPressed: () { 
            _submitAndUpdateFirebase();
            Navigator.pop(context);
            }
        ),
      ),
    );
  }

  Widget _buildSteps() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final currentNum = index + 1;
                      return ListTile(
                        leading: Text(currentNum.toString()),
                        title: Text(steps[index]),
                       
                      );
                    },
                    itemCount: steps.length,
                  )
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: MaterialButton(
              child: Icon(Icons.add_box),
              onPressed: () {
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => EditSteps(steps))
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _submitAndUpdateFirebase() {
    _key.currentState.save();
    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference =
          Firestore.instance.collection('testRecipes');
      await reference.add({
        'id': id,
        // all recipes are created private by default
        // TODO: create button for users to share recipe, so isShared will = true.
        'isShared': false,
        'date': date,
        'beanName': beanName,
        'brewer': brewer,
        //'steps' : steps,
        'tastingNotes': tastingNotes,
        'userId': userId,
      });
      print("successful!");
    });
  }
}
