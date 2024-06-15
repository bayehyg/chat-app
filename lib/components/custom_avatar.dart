import 'package:chat_app/screens/user_profle_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';

import '../constants.dart';
import 'User.dart';

class CustomAvatar extends StatelessWidget {
  final ChatUser user;
  const CustomAvatar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProfileScreen(user: user);
        }));
      },
      child: AppBar(
        backgroundColor:
            Color(0xff141414), // Set the background color of the AppBar
        leading: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
            child: RandomAvatar(user.avatarName, height: 50, width: 50)),
        title: Text(
          "${user.firstName} ${user.lastName}",
          style: kNameTextStyle,
        ), // Replace with the actual user name
      ),
    );
  }
}
