import 'package:coffee_app/styles.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class EditSteps extends StatefulWidget {

  EditSteps(this.steps);
  List<StepData> steps;

  @override
  _EditStepsState createState() => _EditStepsState();
}

class _EditStepsState extends State<EditSteps> {
  List<StepData> currentSteps = [];
  var uuid = new Uuid();

  @override
  void initState() {
    super.initState();
    currentSteps = widget.steps;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text('edit your steps'),
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: currentSteps.length,
          itemBuilder: (context, index) {
            final currentNum = index + 1;
            String currentEntry = currentSteps[index].indivStep;
            return Column(
              children: <Widget>[
                Dismissible(
                  background: Container(
                    color: Colors.red,
                  ),
                  key: Key(currentSteps[index].id),
                  child: ListTile(
                      leading: Text(currentNum.toString()),
                      title: Text(currentSteps[index].indivStep),
                      trailing: MaterialButton(
                        child: Icon(Icons.edit),
                        onPressed: () {
                          _editTextDialog(currentEntry, index);
                        },
                      )),
                  onDismissed: (direction) {
                    removeStep(index);
                  },
                ),
                Divider(),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text("Add Step"),
        onPressed: () {
          setState(() {
            StepData temp = new StepData(indivStep: "", id: uuid.v4());
            currentSteps.add(temp);
            _editTextDialog(
                temp.indivStep, currentSteps.indexOf(currentSteps.last));
          });
        },
      ),
    );
  }

  void removeStep(int index) {
    setState(() {
      currentSteps.removeAt(index);
    });
  }

  void _editTextDialog(String currentEntry, int index) {
    final _formKey = GlobalKey<FormState>();
    String newEntry = currentEntry;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Edit Step"),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    initialValue: currentEntry,
                    decoration: InputDecoration(hintText: "Enter steps here"),
                    keyboardType: TextInputType.multiline,
                    onSaved: (value) => newEntry = value,
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      cancelButton(context),
                      Divider(),
                      FlatButton(
                        color: Colors.blue[200],
                        child: Icon(Icons.check_circle_outline),
                        onPressed: () {
                          _formKey.currentState.save();
                          setState(() {
                            currentSteps[index].indivStep = newEntry;
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget cancelButton(BuildContext context) {
    return FlatButton(
      color: Colors.red[400],
      child: Icon(Icons.close),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}

class StepData {
  var uuid = new Uuid();
  String id;
  String indivStep;

  StepData({this.id, this.indivStep});

  List<String> convertToListOfStrings(List<StepData> stepDataList) {
    // List<String> result = [];
    // for (int i = 0; i < stepDataList.length; ++i) {
    //   result.add(stepDataList[i].indivStep);
    // }
    // return result;
    return stepDataList.map((x) => x.indivStep).toList();
  }

  List<StepData> convertToListOfStepData(List<String> listStrings) {
    List<StepData> result = [];
    for (int i = 0; i < listStrings.length; ++i) {
      StepData temp = new StepData(indivStep: listStrings[i], id: uuid.v4());
      result.add(temp);
    }
    return result;
  }
}
