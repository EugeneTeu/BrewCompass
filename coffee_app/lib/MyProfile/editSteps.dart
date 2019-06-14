import 'package:coffee_app/misc/zoom-image.dart';
import 'package:flutter/material.dart';
//TODO: implement stepper class inside here
class EditSteps extends StatefulWidget {
  EditSteps(this.steps);
  List steps;

  @override
  _EditStepsState createState() => _EditStepsState();
}

class _EditStepsState extends State<EditSteps> {
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
      body: ListView.builder(
        itemBuilder: (context, index) {
          final currentNum = index + 1;
          return ListTile(
            leading: Text(currentNum.toString()),
            title: Text(widget.steps[index]),
          );
        },
        itemCount: widget.steps.length,
      ),
    );
  }
}
