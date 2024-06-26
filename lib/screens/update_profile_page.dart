// import 'package:flutter/material.dart';
// import 'package:line_awesome_flutter/line_awesome_flutter.dart';
//
// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     double widthRef = MediaQuery.of(context).size.width;
//     double heightRef = MediaQuery.of(context).size.height;
//     var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//             onPressed: () => (){
//               Navigator.pop(context);
//             },
//             icon: const Icon(LineAwesomeIcons.angle_left_solid)),
//         title: Text("profile", style: Theme.of(context).textTheme.headlineLarge),
//         actions: [
//           IconButton(
//               onPressed: () {},
//               icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon))
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.all(widthRef / 100),
//           child: Column(
//             children: [
//               /// -- IMAGE
//               Stack(
//                 children: [
//                   SizedBox(
//                     width: 120,
//                     height: 120,
//                     child: ClipRRect(
//                         borderRadius: BorderRadius.circular(100),
//                         child: ),
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: Container(
//                       width: 35,
//                       height: 35,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(100),
//                           color: tPrimaryColor),
//                       child: const Icon(
//                         LineAwesomeIcons.alternate_pencil,
//                         color: Colors.black,
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               Text(tProfileHeading,
//                   style: Theme.of(context).textTheme.headline4),
//               Text(tProfileSubHeading,
//                   style: Theme.of(context).textTheme.bodyText2),
//               const SizedBox(height: 20),
//
//               /// -- BUTTON
//               SizedBox(
//                 width: 200,
//                 child: ElevatedButton(
//                   onPressed: () => Get.to(() => const UpdateProfileScreen()),
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor: tPrimaryColor,
//                       side: BorderSide.none,
//                       shape: const StadiumBorder()),
//                   child: const Text(tEditProfile,
//                       style: TextStyle(color: tDarkColor)),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               const Divider(),
//               const SizedBox(height: 10),
//
//               /// -- MENU
//               ProfileMenuWidget(
//                   title: "Settings",
//                   icon: LineAwesomeIcons.cog,
//                   onPress: () {}),
//               ProfileMenuWidget(
//                   title: "Billing Details",
//                   icon: LineAwesomeIcons.wallet,
//                   onPress: () {}),
//               ProfileMenuWidget(
//                   title: "User Management",
//                   icon: LineAwesomeIcons.user_check,
//                   onPress: () {}),
//               const Divider(),
//               const SizedBox(height: 10),
//               ProfileMenuWidget(
//                   title: "Information",
//                   icon: LineAwesomeIcons.info,
//                   onPress: () {}),
//               ProfileMenuWidget(
//                   title: "Logout",
//                   icon: LineAwesomeIcons.alternate_sign_out,
//                   textColor: Colors.red,
//                   endIcon: false,
//                   onPress: () {
//                     Get.defaultDialog(
//                       title: "LOGOUT",
//                       titleStyle: const TextStyle(fontSize: 20),
//                       content: const Padding(
//                         padding: EdgeInsets.symmetric(vertical: 15.0),
//                         child: Text("Are you sure, you want to Logout?"),
//                       ),
//                       confirm: Expanded(
//                         child: ElevatedButton(
//                           onPressed: () =>
//                               AuthenticationRepository.instance.logout(),
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.redAccent,
//                               side: BorderSide.none),
//                           child: const Text("Yes"),
//                         ),
//                       ),
//                       cancel: OutlinedButton(
//                           onPressed: () => Get.back(), child: const Text("No")),
//                     );
//                   }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
