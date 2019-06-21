import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_app/MyProfile/Recipe.dart';
import 'package:coffee_app/MyProfile/editSteps.dart';
import 'package:coffee_app/auth.dart';
import 'package:coffee_app/misc/brew-guide.dart';
import 'package:coffee_app/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditEntry extends StatefulWidget {
  EditEntry(this.data);

  DocumentSnapshot data;
  @override
  State<StatefulWidget> createState() {
    return _EditEntryState(data);
  }
}

class _EditEntryState extends State<EditEntry> {

  _EditEntryState(data) : this.currentData = data;
  DocumentSnapshot currentData;
  Recipe recipe; 

  GlobalKey<FormState> _key = GlobalKey();
 
  int id;
  bool isShared = false;
  String date;
  String beanName;
  String brewer;
  List<StepData> steps = [];
  String tastingNotes;
  String userId = '';

   @override
  void initState() {
    super.initState();
    this.recipe = Recipe.fromSnapshot(currentData);
    this.id = recipe.id;
    this.isShared = recipe.isShared;
    this.date = recipe.date;
    this.beanName = recipe.beanName;
    this.brewer = recipe.brewer;
    this.steps = _convertList(recipe.steps);
    this.tastingNotes = recipe.tastingNotes;
    this.userId = recipe.userId;
  }

  //casts List<dynamic> to List<String> then converting
  List<StepData> _convertList(List<dynamic> step) {
    var temp = new List<String>.from(step);
    List<StepData> result = StepData().convertToListOfStepData(temp);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    Widget shareButton = _buildShareButton();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        //remove backbutton
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Edit Current Entry"),
        actions: <Widget>[
          MaterialButton(
            child: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Container(
          child: Form(
            key: _key,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 40.0),
              child: SingleChildScrollView(
                  child: Column(
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
                    _buildLabel("Taste log"),
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
                    Divider(),
                    shareButton,
                    _buildSubmitButton(),
                    Divider(),
                  ],
                ),
              ),
            ),
          ),
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

  Widget _buildInputFieldNum() {
    return Padding(
      child: TextFormField(
        style: Styles.createEntryText,
        decoration: new InputDecoration(hintText: "Enter id"),
        initialValue: id.toString(),
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
        initialValue: date,
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
        initialValue: beanName,
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
        initialValue: brewer,
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
            initialValue: tastingNotes,
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
            child: Text("Edit this Entry"),
            onPressed: () {
              _submitAndUpdateFirebase();
              Navigator.pop(context);
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
            child: MaterialButton(
              child: Icon(Icons.add_box),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditSteps(steps)));
              },
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
     Firestore.instance
              .collection("testRecipes")
              .document(widget.data.documentID)
              .delete()
              .catchError((e) {
            print(e);
          });
    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference =
          Firestore.instance.collection('testRecipes');
      await reference.add({
        'id': id,
        // all recipes are created private by default
        'isShared': isShared,
        'date': date,
        'beanName': beanName,
        'brewer': brewer,
        // TODO: extract string of steps from the class of StepData
        'steps': stepsString,
        'tastingNotes': tastingNotes,
        'userId': userId,
      });
      print("edited successfully!");
      
    });
  }
}
