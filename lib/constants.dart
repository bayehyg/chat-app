import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final kMainThemeData = ThemeData.dark().copyWith(
  buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xff5727B6), textTheme: ButtonTextTheme.primary),
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(
      color: Color(0XFF222222),
    ),
    color: Color(0xffFFFFFF),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Color(0XFF222222),
    ),
  ),
  scaffoldBackgroundColor: Color(0xffFFFFFF),
  textTheme: TextTheme(
    titleLarge: TextStyle(color: Color(0XFF222222)),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
  ),
);

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kNameTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

var kLogoTextStyle = GoogleFonts.aldrich(
  textStyle: const TextStyle(
    color: Color(0xff333333),
    fontSize: 45,
    fontWeight: FontWeight.w900,
  ),
);

const kTextFieldDecoration = InputDecoration(
  hintStyle: TextStyle(color: Color(0xff808080)),
  hintText: '',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
