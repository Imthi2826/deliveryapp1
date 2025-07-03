import 'package:flutter/material.dart';

class AppWidget{

  //Onboarding Ttextstyle
  static TextStyle lineTextFieldStyle(){
    return TextStyle(
      color: Colors.black,
      fontSize: 40.0,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle simplelineTextFieldStyle(){
    return TextStyle(
      color: Colors.black,
      fontSize: 20.0,

    );

  }
  //Homepage TextStyle
  static TextStyle onelineTextFieldStyle() {
    return TextStyle(
      color: Color(0xf45e3070),
      fontSize: 30.0,
        fontWeight: FontWeight.bold

    );

  }
  static TextStyle twolineTextFieldStyle() {
    return TextStyle(
      color: Color(0xf45e3070),
      fontSize: 36.0,
        fontWeight: FontWeight.bold

    );
  }
  static TextStyle threelineTextFieldStyle() {
    return TextStyle(
      color: Color(0xf45e3070),
      fontSize: 30.0,
      fontWeight: FontWeight.bold

    );
  }
}