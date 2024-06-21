import 'package:chat_app/components/User.dart';
import 'package:chat_app/screens/profile_menu.dart';
import 'package:chat_app/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:line_icons/line_icon.dart';
import 'package:random_avatar/random_avatar.dart';

class ViewFriendProfilePage extends StatefulWidget {
  final ChatUser user;
  const ViewFriendProfilePage({
    super.key,
    required this.user,
  }); //required this.avatar});

  @override
  State<ViewFriendProfilePage> createState() => _ViewFriendProfilePageState();
}

class _ViewFriendProfilePageState extends State<ViewFriendProfilePage> {
  final Color blue = Color(0xff9509be);
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
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffc263de),
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: const Text("Message",
                      style: TextStyle(
                          color: Color(0xff303030),
                          fontSize: 15,
                          fontWeight: FontWeight.w900)),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
