import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/auth.dart';
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
  String date;
  String beanName;
  String brewer;
  List steps;
  String tastingNotes;
  String userId ='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text("Add new entry"),
          leading: BackButton(
            color: Colors.black,
          )),
      body: Form(
        key: _key,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildInputFieldNum(),
            _buildInputFieldDate(),
            _buildInputFieldBeanName(),
            _buildInputFieldBrewer(),
            _buildInputFieldTastingNotes(),
            _buildSubmitButton(),
          ],
        ),
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
      padding: EdgeInsets.all(40.0),
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
      padding: EdgeInsets.all(40.0),
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
      padding: EdgeInsets.all(40.0),
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
      padding: EdgeInsets.all(40.0),
    );
  }
    Widget _buildInputFieldTastingNotes() {
    return Padding(
      child: TextFormField(
        style: Styles.createEntryText,
        decoration: new InputDecoration(hintText: "Enter tasting notes"),
        keyboardType: TextInputType.text,
        validator: (value) => value.isEmpty ? "field cant be empty" : null,
        onSaved: (value) => this.tastingNotes = value,
      ),
      padding: EdgeInsets.all(40.0),
    );
  }

 

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: MaterialButton(
          color: Colors.brown[400],
          child: Text("Create Entry"),
          onPressed: () => _submitAndUpdateFirebase(),
        ),
      ),
    );
  }

  void _submitAndUpdateFirebase() {
  
    _key.currentState.save();
    Firestore.instance.runTransaction(
      (Transaction transaction) async {
        CollectionReference reference = Firestore.instance.collection('testRecipes');
        await reference.add({ 
          'id' : id,
          'date' : date,
          'beanName' : beanName,
          'brewer' : brewer,
          //'steps' : steps,
          'tasting Notes' : tastingNotes,
          'userId' : userId,
          });
          print("successful!");
      }
     );
  }
}
