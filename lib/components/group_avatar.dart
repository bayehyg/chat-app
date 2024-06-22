import 'package:chat_app/screens/group_profile_page.dart';
import 'package:chat_app/screens/user_profle_page.dart';
import 'package:chat_app/screens/view_friend_profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_avatar/random_avatar.dart';

import 'User.dart';

class GroupAvatar extends StatelessWidget {
  final String groupName;
  final List<ChatUser> users;
  const GroupAvatar({super.key, required this.groupName, required this.users});

  @override
  Widget build(BuildContext context) {
    double widthRef = MediaQuery.of(context).size.width;

    return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return GroupProfilePage(
              users: users,
              groupName: groupName,
            );
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
              CircleAvatar(
                radius: widthRef / 14,
                backgroundColor: Colors.green,
                child: Text(groupName[0]),
              ),
              SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(groupName,
                      style: GoogleFonts.openSans(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20)),
                  SizedBox(height: 8.0),
                  Text(
                    "${users.length} members",
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
