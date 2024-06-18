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
  late FocusNode textFieldFocusNode;
  late String email;
  late String password;
  bool showSpin = false;

  void _navigateToChatScreen() {
    Navigator.pushNamed(context, ChatScreen.id);
  }

  @override
  void initState() {
    // TODO: implement initState
    textFieldFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double heightReference = MediaQuery.of(context).size.height;
    double widthReference = MediaQuery.of(context).size.width;
    textFieldFocusNode.addListener(() {
      setState(() {});
    });
    return CustomBackground(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: heightReference / 15, bottom: heightReference / 20),
                child: Text(
                  "sign up",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 50, color: Colors.white),
                ),
              ),
              ModalProgressHUD(
                inAsyncCall: showSpin,
                child: Padding(
                  padding: EdgeInsets.only(
                      right: widthReference / 20,
                      left: widthReference / 20,
                      bottom: heightReference / 7),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Color(0xff4C2C8D),
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Hero(
                          tag: 'logo',
                          child: SizedBox(
                            height: !textFieldFocusNode.hasFocus
                                ? heightReference / 5
                                : 0,
                            child: Image.asset('images/logo.png'),
                          ),
                        ),
                        SizedBox(
                          height: heightReference / 12,
                        ),
                        TextField(
                          focusNode: textFieldFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            email = value;
                          },
                          style: kNameTextStyle,
                          decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Enter your email'),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        TextField(
                          focusNode: textFieldFocusNode,
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
                          color: Colors.blueAccent,
                          title: 'Register',
                          onPress: () async {
                            setState(() {
                              showSpin = true;
                            });
                            try {
                              final newUser =
                                  await _auth.createUserWithEmailAndPassword(
                                      email: email, password: password);
                              if (newUser.user != null) _navigateToChatScreen();
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
