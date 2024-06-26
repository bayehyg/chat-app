import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/addUserPage.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/screens/welcome_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/registration_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:permission_handler/permission_handler.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> requestPermissions() async {
  bool allGranted = true;

  var statuses = await [
    Permission.mediaLibrary,
    Permission.storage,
    Permission.photos,
    Permission.camera,
  ].request();

  statuses.forEach((permission, status) {
    if (!status.isGranted) {
      allGranted = false;
      return;
    }
  });

  if (!allGranted && navigatorKey.currentContext != null) {
    // Show a dialog or a message to the user explaining why the permissions are needed
    await showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: Text('Permissions Required'),
        content: Text(
            'This app needs camera and photo permissions to function properly.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const FlashChat());
}

class FlashChat extends StatelessWidget {
  const FlashChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: kMainThemeData,
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        RegistrationScreen.id: (context) => const RegistrationScreen(),
        ChatScreen.id: (context) => const ChatScreen(),
        AddUserPage.id: (context) => AddUserPage(),
      },
    );
  }
}
