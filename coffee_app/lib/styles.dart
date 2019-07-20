// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class Styles {
  static const TextStyle calcFont = TextStyle(
      fontWeight: FontWeight.w300, fontSize: 22.0, fontFamily: "OpenSans");

  static const TextStyle createEntryText = TextStyle(
    color: Colors.black,
    fontFamily: "OpenSans",
  );

  static const TextStyle splashScreenTitleText = TextStyle(
      fontFamily: "OpenSans",
      fontSize: 55.0,
      color: Colors.white70,
      fontStyle: FontStyle.italic);

  static const TextStyle drawerTitleText = TextStyle(
      fontFamily: "OpenSans",
      fontSize: 25.0,
      color: Colors.white70,
      fontStyle: FontStyle.italic);

  static const TextStyle drawerSubtitleText = TextStyle(
      fontFamily: "OpenSans",
      fontSize: 20.0,
      color: Colors.white54,
      fontStyle: FontStyle.italic);

  static const TextStyle mainAppBarText = TextStyle(
      fontFamily: "OpenSans",
      fontSize: 20.0,
      color: Colors.black,
      fontStyle: FontStyle.italic);
    static const TextStyle utilityTabBarText = TextStyle(
      fontFamily: "OpenSans",
      fontSize: 15.0,
      color: Colors.black,
      fontStyle: FontStyle.italic);

  static const TextStyle entryLabelsText = TextStyle(
      color: Colors.black, fontFamily: "OpenSans", fontWeight: FontWeight.w800);

  static const TextStyle loginText = TextStyle(
    color: Colors.white,
    fontFamily: "OpenSans",
  );

  static const Color productRowDivider = Color(0xFFD9D9D9);
  static const TextStyle profileStyle = TextStyle(
    fontFamily: "OpenSans",
    fontSize: 20.0,
    color: Colors.black,
  );

   static const TextStyle profileInfoStyle = TextStyle(
    fontFamily: "OpenSans",
    fontSize: 13.0,
    color: Colors.black87,
  );

  static const TextStyle filterButton = TextStyle(
    fontFamily: "OpenSans",
    fontSize: 15.0,
    color: Colors.white,
  );

  static const Color scaffoldBackground = Color(0xfff0f0f0);
  static const Color searchBackground = Color(0xffe0e0e0);
  static const Color searchCursorColor = Color.fromRGBO(0, 122, 255, 1);
  static const Color searchIconColor = Color.fromRGBO(128, 128, 128, 1);
  static const TextStyle searchText = TextStyle(
      color: Color.fromRGBO(0, 0, 0, 1),
      fontSize: 14,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.normal,
      fontFamily: "OpenSans");

  static const TextStyle textStyle =
      TextStyle(fontSize: 90.0, fontFamily: "OpenSans"
          //"Bebas Neue"
          );
}
