import 'package:flutter/material.dart';
import 'package:chat_app/screens/welcome_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/registration_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FutureBuilder(
    // Pass the function that returns a Future
    future: Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ),
    builder: (context, snapshot) {
      // Check the connection state of the snapshot
      if (snapshot.connectionState == ConnectionState.waiting) {
        // Return a loading indicator widget
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (snapshot.hasError) {
        // Return an error widget
        return Center(
          child: Text('Something went wrong'),
        );
      } else {
        // Return the widget that depends on Firebase
        return FlashChat();
      }
    },
  );
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: WelcomeScreen.id,
      routes:  {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
