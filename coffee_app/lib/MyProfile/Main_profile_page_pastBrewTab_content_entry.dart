import 'package:coffee_app/MyProfile/Recipe.dart';
import 'package:coffee_app/misc/brew-guide.dart';
import 'package:flutter/material.dart';

import '../styles.dart';

class JournalEntry extends StatelessWidget {
  final Recipe currentRecipe;

  JournalEntry(Recipe currentEntry) : this.currentRecipe = currentEntry;

@override
  Widget build(BuildContext context) {
    // Widget shareButton = _buildShareButton();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        //remove backbutton
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Viewing Entry"),
        actions: <Widget>[
          MaterialButton(
            child: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            _buildLabel("Brew Details"),
            Row(
              children: <Widget>[
                Expanded(flex: 2, child: _buildFormattedText('ID:')),
                Expanded(flex: 4, child: _buildFormattedText('${currentRecipe.id}')),
                Expanded(flex: 3, child: _buildFormattedText('Date:')),
                Expanded(flex: 4, child: _buildFormattedText('${currentRecipe.date}')),
              ],
            ),
            _buildLabel("Bean Name"),
            _buildFormattedText('${currentRecipe.beanName}'),
            _buildLabel("Brewer"),
            _buildFormattedText('${currentRecipe.brewer}'),
            _buildLabel("Taste log"),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(flex: 10, child: _buildFormattedText('${currentRecipe.tastingNotes}')),
                Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: MaterialButton(
                        color: Theme.of(context).primaryColor,
                        child: Text("Reference"),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BrewGuideChart()));
                        },
                      ),
                    )
                ),
              ],
            ),
            Divider(),
            _buildLabel("Steps"),
            _buildSteps(),

          ],
        ),
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

  Widget _buildFormattedText(String text) {
    return Padding(
      child: Text('$text'),
      padding: EdgeInsets.all(20.0),
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
                        title: Text(currentRecipe.steps[index]),
                      );
                    },
                    itemCount: currentRecipe.steps.length,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}

/*
// TODO: remodel this whole thing to 
// become the same as edit steps, except that there are no edit buttons
class JournalEntry extends StatelessWidget {
  
  final Recipe currentRecipe;

  JournalEntry(Recipe currentEntry) : this.currentRecipe = currentEntry;

  //List<Widget> steps = currentRecipe.steps.map((steps) => Text(steps)).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("This brew"),
          leading: BackButton(
            color: Colors.black,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Divider(),
              Text(currentRecipe.beanName != null ? currentRecipe.beanName : 'bean name here'),
              Divider(),
              Text(currentRecipe.brewer != null ? currentRecipe.brewer : 'brewer here'),
              Divider(),
              Text(currentRecipe.tastingNotes != null ? 
                  currentRecipe.tastingNotes : 'tasting notes here'),
              Divider(),
              Text(currentRecipe.date != null ? currentRecipe.date : 'Date here'),
              Divider(),
              Column(
                children:
                    currentRecipe.steps != null ? currentRecipe.steps.map((steps) => Text(steps)).toList() : [Text("steps here")],
              ),
            ],
          ),
        ));
  }
}
*/