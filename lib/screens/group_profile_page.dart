import 'package:chat_app/components/User.dart';
import 'package:chat_app/components/custom_avatar.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class GroupProfilePage extends StatefulWidget {
  final String groupName;
  final List<ChatUser> users;
  const GroupProfilePage({
    super.key,
    required this.users,
    required this.groupName,
  }); //required this.avatar});

  @override
  State<GroupProfilePage> createState() => _GroupProfilePageState();
}

class _GroupProfilePageState extends State<GroupProfilePage> {
  final Color blue = Color(0xff9509be);
  var isDark = true;
  @override
  Widget build(BuildContext context) {
    double widthRef = MediaQuery.of(context).size.width;
    double heightRef = MediaQuery.of(context).size.height;

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
                  CircleAvatar(
                      radius: widthRef / 6,
                      backgroundColor: Colors.green,
                      child: Text(
                        widget.groupName[0],
                        style: TextStyle(fontSize: widthRef / 10),
                      ))
                ],
              ),
              SizedBox(height: heightRef / 60),
              Text(widget.groupName,
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(color: isDark ? Colors.white : null)),

              /// -- BUTTON
              SizedBox(height: heightRef / 50),
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
                  child: Text("Message",
                      style: TextStyle(
                          color: Color(0xff303030),
                          fontSize: widthRef / 20,
                          fontWeight: FontWeight.w900)),
                ),
              ),
              SizedBox(height: heightRef / 50),
              const Divider(),
              SizedBox(height: heightRef / 100),
              for (ChatUser user in widget.users) CustomAvatar(user: user),
            ],
          ),
        ),
      ),
    );
  }
}
