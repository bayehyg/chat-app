import 'package:chat_app/screens/background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/roundedButton.dart';
import '../constants.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  late var email;
  late var password;
  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
        TextField(
          keyboardType: TextInputType.emailAddress,
          textAlign: TextAlign.center,
          onChanged: (value) {
            email = value;
          },
          style: kNameTextStyle,
          decoration: kTextFieldDecoration.copyWith(
              hintText: 'Enter your email'
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        TextField(
          obscureText: true,
          textAlign: TextAlign.center,
          onChanged: (value) {
            password = value;
          },
          style: kNameTextStyle,
          decoration: kTextFieldDecoration.copyWith(
              hintText: 'Enter your password'
          ),
        ),
            SizedBox(
              height: 24.0,
            ),
            RoundedButton(
              title: 'Log in',
              color: Colors.lightBlueAccent,
              onPress: (){
                try {
                  final user = _auth.signInWithEmailAndPassword(email: email, password: password);

                } catch (e) {
                  print(e);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
