import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

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
          // ZoomableImage(new AssetImage('assets/Coffee-Compass.jpg'))
          PhotoView(
            imageProvider: AssetImage('assets/Coffee-Compass.jpg'),
          ),
        ],
      ),
    );
  }
}
