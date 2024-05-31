import 'package:chat_app/components/roundedButton.dart';
import 'package:chat_app/screens/background.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../constants.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  const RegistrationScreen({super.key});
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool showSpin = false;

  void _navigateToChatScreen(){
    Navigator.pushNamed(context, ChatScreen.id);
  }
  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      body: ModalProgressHUD(
        inAsyncCall: showSpin,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: SizedBox(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              const SizedBox(
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
              const SizedBox(
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
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                color: Colors.blueAccent,
                title: 'Register',
                onPress: () async{
                  setState(() {
                    showSpin = true;
                  });
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                    if(newUser.user != null) _navigateToChatScreen();
                    setState(() {
                      showSpin = false;
                    });
                  } catch (e) {
                    print(e);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
