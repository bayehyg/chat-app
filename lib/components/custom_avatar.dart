import 'package:chat_app/screens/user_profle_page.dart';
import 'package:chat_app/screens/view_friend_profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';

import '../constants.dart';
import 'User.dart';

class CustomAvatar extends StatelessWidget {
  final ChatUser user;
  const CustomAvatar({super.key, required this.user});

  String formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final difference = now.difference(lastSeen);

    if (difference.inMinutes < 60) {
      return 'Seen ${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else if (difference.inHours < 24) {
      return 'Seen ${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else {
      final days = difference.inDays;
      return 'Seen $days day${days == 1 ? '' : 's'} ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthRef = MediaQuery.of(context).size.width;

    return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ViewFriendProfilePage(user: user);
          }));
        },
        child: Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Color(0x132f3031),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 0.1,
                blurRadius: 0,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              RandomAvatar(user.avatarName, width: widthRef / 7),
              SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.getFullName(),
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    formatLastSeen(user.lastSeen),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
