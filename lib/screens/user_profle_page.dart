import 'package:chat_app/components/User.dart';
import 'package:chat_app/screens/profile_menu.dart';
import 'package:chat_app/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:random_avatar/random_avatar.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({
    super.key,
    required this.user,
  }); //required this.avatar});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Color yellow = Color(0xffFFE501);
  final Color blue = Color(0xff007BFF);
  var isDark = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: isDark ? const Color(0xff303030) : Color(0xffFAFAFA),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(LineAwesomeIcons.angle_left_solid)),
        title: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 4.6,
          ),
          child: Text(
            "Profile",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: isDark ? Colors.white : null,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              /// -- IMAGE
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child:
                            null), // TODO: const Image(image: AssetImage(""))),
                  ),
                  RandomAvatar(
                    widget.user.avatarName,
                    width: 130,
                    height: 130,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(widget.user.getFullName(),
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(color: isDark ? Colors.white : null)),
              Text(widget.user.email,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),

              /// -- BUTTON
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => () {
                    // TODO: implement this
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: yellow,
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: const Text("Edit profile",
                      style: TextStyle(color: Color(0xff303030), fontSize: 15)),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                  title: "Logout",
                  icon: LineAwesomeIcons.sign_out_alt_solid,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("LOGOUT"),
                          titleTextStyle: const TextStyle(fontSize: 20),
                          content: Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Are you sure, you want to Logout?"),
                                ElevatedButton(
                                  onPressed: () {
                                    FirebaseAuth.instance.signOut();
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const WelcomeScreen()),
                                      (Route<dynamic> route) => false,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      side: BorderSide.none),
                                  child: const Text("Yes"),
                                ),
                                OutlinedButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text("No")),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
