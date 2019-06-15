import 'package:coffee_app/styles.dart';
import 'package:flutter/material.dart';

class EditSteps extends StatefulWidget {
  EditSteps(this.steps);
  List steps;

  @override
  _EditStepsState createState() => _EditStepsState();
}

class _EditStepsState extends State<EditSteps> {
 

  List currentSteps = [];

  @override
  void initState() {
    super.initState();
    currentSteps = widget.steps;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('edit your steps'),
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: currentSteps.length,
              itemBuilder: (context, index) {
                final currentNum = index + 1;
                String currentEntry = currentSteps[index];
                return Dismissible(
                  background: Container(
                    color: Colors.red,
                  ),
                  key: Key(currentEntry),
                  child: ListTile(
                      leading: Text(currentNum.toString()),
                      title: Text(currentEntry),
                      trailing: MaterialButton(
                        child: Icon(Icons.edit),
                        onPressed: () {
                          _editTextDialog(currentEntry, index);
                        },
                      )),
                  onDismissed: (direction) {
                    removeStep(index);
                  },
                );
              },
            ),
          ),
          MaterialButton(
            color: Colors.brown[200],
            child: Text(
              "add step",
              style: Styles.createEntryText,
            ),
            onPressed: () {
              setState(() {
                String temp = "Enter new steps";
                currentSteps.add(temp);
              });
            },
          ),
          Divider(),
        ],
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
                    keyboardType: TextInputType.multiline,
                    onSaved: (value) => newEntry = value,
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton(
                        color: Colors.blue[200],
                        child: Icon(Icons.check_circle_outline),
                        onPressed: () {
                          _formKey.currentState.save();
                          setState(() {
                            currentSteps[index] = newEntry;                            
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                      Divider(),
                      cancelButton(context),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget cancelButton(BuildContext context) {
    return MaterialButton(
      color: Colors.red[400],
      child: Icon(Icons.close),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}

/**
 *  int currentStep = 0;
  bool complete = false;

  List<Step> steps1 = [
    Step(
      title: Text("step"),
      isActive: true,
      state: StepState.complete,
      content: Column(
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            decoration: InputDecoration(
                hintText: "Enter your step", hintStyle: Styles.createEntryText),
          )
        ],
      ),
    ),
    Step(
      isActive: false,
      state: StepState.complete,
      title: Text("step"),
      content: Column(
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            decoration: InputDecoration(
                hintText: "Enter your step", hintStyle: Styles.createEntryText),
          )
        ],
      ),
    )
  ];


 next() {
    if(currentStep + 1 != steps1.length) {
      goTo(currentStep +1);
    } else {
      setState(() {
        complete = true;
      });
    }
   
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

   goTo(int step) {
    setState(() {
      currentStep = step;
    });
  }

  Step singleStep = Step(
    title: Text("step"),
    content: Column(
      children: <Widget>[
        TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: 5,
          decoration: InputDecoration(
              hintText: "Enter your step", hintStyle: Styles.createEntryText),
        )
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('edit your steps'),
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stepper(
              steps: steps1,
              currentStep: currentStep,
              onStepContinue: next(),
              onStepCancel: cancel,
               onStepTapped: (step) => goTo(step),
            ),
          ),
        ],
      ),
    );
  }

  List<Step> _buildStep() {}
}
 */
