import 'package:chat_app/screens/background.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/registration_screen.dart';
import 'package:flutter/material.dart';

import '../components/roundedButton.dart';
import '../constants.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';

  const WelcomeScreen({super.key});
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: animation.value * 150,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Text('CodeBand',
                    style: kLogoTextStyle.copyWith(
                        fontSize: 60, color: const Color(0xfff1f1f1))),
              ],
            ),
            SizedBox(
              height: animation.value * 48.0,
            ),
            Hero(
              tag: 'log_in_btn',
              child: RoundedButton(
                color: Color(0xffad3c29),
                title: 'Log in',
                onPress: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
              ),
            ),
            Hero(
              tag: 'rgtr_btn',
              child: RoundedButton(
                color: Color(0xff1e1d1d),
                title: 'Register',
                onPress: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
