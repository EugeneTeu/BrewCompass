import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/MyProfile/editSteps.dart';
import 'package:coffee_app/auth.dart';
import 'package:coffee_app/auth_provider.dart';
import 'package:coffee_app/misc/brew-guide.dart';
import 'package:coffee_app/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;

import 'package:open_iconic_flutter/open_iconic_flutter.dart';

class AddNewEntry extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddNewEntryState();
  }
}

class _AddNewEntryState extends State<AddNewEntry> {
  GlobalKey<FormState> _key = GlobalKey();

  //code to get firebase User
  Future<FirebaseUser> _fetchUser() async {
    var auth = AuthProvider.of(context).auth;
    FirebaseUser user = await auth.getUser();
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
        displayName = user.displayName;
      } else {}
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _user();
  }

  //call async method once instead of continually calling _user();
  @override
  void initState() {
    super.initState();
  }

  //id for now is manually entered, need to enable indexing by firebase
  //edit entry flow: take in a form for inputs, push recipe object to database by calling runTransaction
  //TODO: add validator to the fields, add dropdown menu to switches
  int id;
  bool isShared = false;
  String date;
  String beanName;
  String brewer;
  List<StepData> steps = [];
  String tastingNotes;
  String userId = '';
  String displayName = ' ';

  @override
  Widget build(BuildContext context) {
    Widget shareButton = _buildShareButton();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        //remove backbutton
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Add New Entry"),
        actions: <Widget>[
          MaterialButton(
            child: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Column(
          children: <Widget>[
            SizedBox(height: 5.0,),
            Container(
              color: Colors.white,
              child: Form(
                key: _key,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Card(
                    color: Colors.white,
                    elevation: 10.0,
                    child: Column(
                      children: <Widget>[
                        // _buildLabel("Enter ur Brew Details"),
                        //_buildLabel("Date of this brew"),
                        Row(
                          //need to wrap widget in expanded here to give the child widget a size parameter
                          children: <Widget>[
                            /*Flexible(flex: 1, child: _buildInputFieldNum()),*/
                            Flexible(
                              flex: 1,
                              child: _buildInputFieldDate(),
                            ),
                          ],
                        ),
                        Divider(),
                        //_buildLabel("Bean Name"),
                        _buildInputFieldBeanName(),
                        Divider(),
                        //_buildLabel("Brewer"),
                        _buildInputFieldBrewer(),
                        Divider(),
                        //_buildLabel("Taste log"),
                        Row(
                          children: <Widget>[
                            Flexible(
                                flex: 2, child: _buildInputFieldTastingNotes()),
                            Flexible(
                                flex: 1,
                                child: MaterialButton(
                                  color: Colors.brown[400],
                                  child: Text("Reference"),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BrewGuideChart()));
                                  },
                                )),
                          ],
                        ),
                        Divider(),
                        _buildLabel("Enter Your Steps"),
                        _buildSteps(),
                        Divider(),
                        shareButton,
                        _buildSubmitButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
      child: SwitchListTile(
        title: const Text("Share this entry?"),
        value: isShared,
        onChanged: (bool value) {
          setState(() {
            isShared = value;
            print(isShared);
          });
          this.isShared = isShared;
        },
        secondary: const Icon(Icons.lightbulb_outline),
        activeColor: Colors.white,
        activeTrackColor: Colors.green,
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: Colors.red,
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
      child: ListTile(
        title: Text(
          "$text",
          style: Styles.entryLabelsText,
        ),
      ),
    );
  }

  final dateFormat = DateFormat("EEEE, MMMM d, yyyy");
  Widget _buildInputFieldDate() {
    return Padding(
      child: Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.brown[300]),
        child: ListTile(
          leading: Icon(OpenIconicIcons.calendar),
          title: DateTimePickerFormField(
            inputType: InputType.date,
            editable: true,
            decoration: InputDecoration(
                labelText: 'Date', hasFloatingPlaceholder: true),
            format: dateFormat,
            onChanged: (date) {
              this.date = date.toString();
            },
            onSaved: (value) {
              //String dateSlug = "${value.year.toString()}- ${value.month.toString().padLeft(2,'0')}- ${value.day.toString().padLeft(2,'0')}" ;
              var formatter = new DateFormat('dd-MM-yyyy');
              this.date = formatter.format(value).toString();
              print(date);
            },
            enabled: true,
          ),
        ),
      ),
      padding: EdgeInsets.all(20.0),
    );
  }

  Widget _buildInputFieldBeanName() {
    return Padding(
      child: ListTile(
        leading: Icon(OpenIconicIcons.text),
        title: TextFormField(
          style: Styles.createEntryText,
          decoration: new InputDecoration(hintText: "Enter Bean Name"),
          keyboardType: TextInputType.text,
          validator: (value) =>
              value.isEmpty ? "Bean Name cannot be empty" : null,
          onSaved: (value) => this.beanName = value,
        ),
      ),
      padding: EdgeInsets.all(20.0),
    );
  }

  Widget _buildInputFieldBrewer() {
    return Padding(
      child: ListTile(
        leading: Icon(OpenIconicIcons.beaker),
        title: TextFormField(
          style: Styles.createEntryText,
          decoration: new InputDecoration(hintText: "Enter brewer"),
          keyboardType: TextInputType.text,
          validator: (value) => value.isEmpty ? "field cant be empty" : null,
          onSaved: (value) => this.brewer = value,
        ),
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
            }),
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
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final currentNum = index + 1;
                      return ListTile(
                        leading: Text(currentNum.toString()),
                        title: Text(steps[index].indivStep),
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
            child: Column(
              children: <Widget>[
                MaterialButton(
                  child: Icon(
                    Icons.add_box,
                    color: Colors.brown[400],
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditSteps(steps)));
                  },
                ),
                Text(
                  "Add Steps",
                  style: TextStyle(color: Colors.brown[400]),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submitAndUpdateFirebase() {
    setState(() {
      steps = steps;
      isShared = isShared;
    });
    List<String> stepsString = StepData().convertToListOfStrings(steps);
    _key.currentState.save();
    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference =
          Firestore.instance.collection('testRecipesv3');
      await reference.add({
        /*'id': id,*/
        // all recipes are created private by default
        'displayName': displayName,
        'isShared': isShared,
        'date': date,
        'beanName': beanName,
        'brewer': brewer,
        'steps': stepsString,
        'tastingNotes': tastingNotes,
        'userId': userId,
      });
      print("created successfully!");
    });
  }

  void _showErrorWhenSubmitting(NoSuchMethodError e) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          if (Platform.isAndroid) {
            return AlertDialog(
              title: Text("Error Creating Entry"),
              content: Text("Please Try Again"),
              actions: <Widget>[],
            );
          } else if (Platform.isIOS) {
            return CupertinoAlertDialog(
              title: Text("Error Creating Entry"),
              content: Text("Please Try Again"),
              actions: <Widget>[],
            );
          }
        });
  }
}
