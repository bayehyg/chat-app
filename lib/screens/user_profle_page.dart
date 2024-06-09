import 'package:chat_app/screens/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

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
              // TODO: implement this
            },
            icon: Icon(LineAwesomeIcons.angle_left_solid)),
        title:
            Text("Profile", style: Theme.of(context).textTheme.headlineLarge),
        actions: [
          IconButton(
              onPressed: () {
                isDark = !isDark;
              },
              icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon))
        ],
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
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white),
                      child: const Icon(
                        LineAwesomeIcons.pencil_alt_solid,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text("Profile", style: Theme.of(context).textTheme.headlineLarge),
              Text("Benjamin Yield",
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

              /// -- MENU
              ProfileMenuWidget(
                  title: "Settings",
                  icon: Icon(
                    LineAwesomeIcons.cog_solid,
                  ),
                  onPress: () {}),
              ProfileMenuWidget(
                  title: "Billing Details",
                  icon: LineAwesomeIcons.wallet_solid,
                  onPress: () {}),
              ProfileMenuWidget(
                  title: "User Management",
                  icon: LineAwesomeIcons.user_check_solid,
                  onPress: () {}),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                  title: "Information",
                  icon: LineAwesomeIcons.info_circle_solid,
                  onPress: () {}),
              ProfileMenuWidget(
                  title: "Logout",
                  icon: LineAwesomeIcons.sign_out_alt_solid,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {
                    // Get.defaultDialog(
                    //   title: "LOGOUT",
                    //   titleStyle: const TextStyle(fontSize: 20),
                    //   content: const Padding(
                    //     padding: EdgeInsets.symmetric(vertical: 15.0),
                    //     child: Text("Are you sure, you want to Logout?"),
                    //   ),
                    //   confirm: Expanded(
                    //     child: ElevatedButton(
                    //       onPressed: () {
                    //         // TODO: implement this
                    //       },
                    //       style: ElevatedButton.styleFrom(
                    //           backgroundColor: Colors.redAccent,
                    //           side: BorderSide.none),
                    //       child: const Text("Yes"),
                    //     ),
                    //   ),
                    //   cancel: OutlinedButton(
                    //       onPressed: () => Get.back(), child: const Text("No")),
                    // );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
