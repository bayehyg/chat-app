import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final kMainThemeData = ThemeData.dark().copyWith(
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    unselectedIconTheme: IconThemeData(size: 30, color: Colors.grey.shade300),
    backgroundColor: const Color(0xFF1F1F1F),
  ),
  buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xff5727B6), textTheme: ButtonTextTheme.primary),
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(
      color: Color(0XFFffffff),
    ),
    color: Color(0XFF1C1A1B),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Color(0XFFffffff),
    ),
  ),
  scaffoldBackgroundColor: const Color(0XFF1C1A1B),
  textTheme: const TextTheme(
    titleLarge: TextStyle(color: Color(0XFF222222)),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
    headlineLarge: TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    bodyMedium: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: Colors.grey,
    ),
  ),
);

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kNameTextStyle = TextStyle(
  color: Colors.white,
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
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFFFFFFF), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFFFFFFF), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
);
