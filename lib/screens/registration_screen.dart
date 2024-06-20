import 'package:chat_app/UserManager.dart';
import 'package:chat_app/components/roundedButton.dart';
import 'package:chat_app/firestore_adapter.dart';
import 'package:chat_app/screens/background.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../components/User.dart';
import '../constants.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  const RegistrationScreen({super.key});
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirestoreAdapter();
  late FocusNode textFieldFocusNode;
  late String email;
  late String password;
  late String avatarName;
  late String firstName;
  late String lastName;
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
                  "Sign up",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              ModalProgressHUD(
                inAsyncCall: showSpin,
                child: Padding(
                  padding: EdgeInsets.only(
                      right: widthReference / 20,
                      left: widthReference / 20,
                      bottom: heightReference / 20),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Color(0xff2e1369),
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Flexible(
                          child: Hero(
                            tag: 'logo',
                            child: SizedBox(
                              height: !textFieldFocusNode.hasFocus
                                  ? heightReference / 5
                                  : 0,
                              child: Image.asset('images/logo.png'),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: heightReference / 30,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: TextField(
                                focusNode: textFieldFocusNode,
                                keyboardType: TextInputType.emailAddress,
                                textAlign: TextAlign.center,
                                onChanged: (value) {
                                  firstName = value;
                                },
                                style: kNameTextStyle,
                                decoration: kTextFieldDecoration.copyWith(
                                    hintText: 'First name'),
                              ),
                            ),
                            SizedBox(
                              width: widthReference / 20,
                            ),
                            Flexible(
                              child: TextField(
                                focusNode: textFieldFocusNode,
                                keyboardType: TextInputType.emailAddress,
                                textAlign: TextAlign.center,
                                onChanged: (value) {
                                  lastName = value;
                                },
                                style: kNameTextStyle,
                                decoration: kTextFieldDecoration.copyWith(
                                    hintText: 'Last name'),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: heightReference / 70,
                        ),
                        Flexible(
                          child: TextField(
                            focusNode: textFieldFocusNode,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              avatarName = value;
                            },
                            style: kNameTextStyle,
                            decoration: kTextFieldDecoration.copyWith(
                                hintText: 'Avatar name'),
                          ),
                        ),
                        SizedBox(
                          height: heightReference / 70,
                        ),
                        Flexible(
                          child: TextField(
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
                        ),
                        SizedBox(
                          height: heightReference / 70,
                        ),
                        Flexible(
                          child: TextField(
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
                        ),
                        const SizedBox(
                          height: 24.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              RoundedButton(
                color: Color(0xff111111),
                title: 'Register',
                onPress: () async {
                  setState(() {
                    showSpin = true;
                  });
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (newUser.user != null) {
                      ChatUser user = await _firestore.createUser(
                          newUser.user!.uid,
                          firstName,
                          lastName,
                          avatarName,
                          email);
                      UserManager.instance.initializeUser(newUser.user, user);
                      _navigateToChatScreen();
                    }
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
