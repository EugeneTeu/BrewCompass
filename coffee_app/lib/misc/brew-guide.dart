import 'package:coffee_app/misc/zoom-image.dart';
import 'package:flutter/material.dart';

class BrewGuideChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Adjust your brew"),
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ZoomableImage(new AssetImage('assets/Coffee-Compass.jpg'))
        ],
      ),
    );
  }
}
