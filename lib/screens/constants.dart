
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var kFlashChatTextStyle = GoogleFonts.aldrich(
  textStyle: TextStyle(
    color: Color(0xffECECEC),
    fontSize: 45,
    fontWeight: FontWeight.w900,
  ),
);

const kTextFieldDecoration = InputDecoration(
  hintText: '',
  contentPadding:
  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);