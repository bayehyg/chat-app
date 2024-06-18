import 'package:chat_app/screens/background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../components/roundedButton.dart';
import '../constants.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  late var email;
  late var password;
  bool showSpin = false;

  void _navigateToChatScreen() {
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
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
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
                    hintText: 'Enter your password'),
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                  title: 'Log in',
                  color: Colors.lightBlueAccent,
                  onPress: () async {
                    setState(() {
                      showSpin = true;
                    });
                    try {
                      final newUser = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      if (newUser.user != null) _navigateToChatScreen();
                      setState(() {
                        showSpin = false;
                      });
                    } catch (e) {
                      debugPrint(e.toString());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Login failed. Please check your credentials and try again.'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    } finally {
                      setState(() {
                        showSpin = false;
                      });
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
