import 'package:chat_app/components/bottomNavigation.dart';
import 'package:chat_app/components/chatCard.dart';
import 'package:chat_app/components/custom_search_bar.dart';
import 'package:chat_app/components/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:random_avatar/random_avatar.dart';
import '../components/conversations_card.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  late String message;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNav(),
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(CupertinoIcons.gear),
              onPressed: () {
                //Implement logout functionality
              }),
        ],
        title: Text('CodeBand', style: kLogoTextStyle.copyWith(fontSize: 27, color: Color(0xfff1f1f1))),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CustomSearchBar(),
            ListView.builder(
              reverse: true,
              itemCount: 1,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                return ConversationList(
                  name: 'Yonatan',
                  messageText: 'How you doing?',
                  imageUrl: '',
                  time: '2:10',
                  isMessageRead: (index == 0 || index == 3)?true:false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// StreamBuilder<QuerySnapshot>(
//     stream: _firestore.collection('messages').snapshots(),
//     builder: (context, snapshot) {
//       if (snapshot.hasData) {
//         final messages = snapshot.data;
//       }
//       return Container();
//     }),
// Container(
//   decoration: kMessageContainerDecoration,
//   child: Row(
//     crossAxisAlignment: CrossAxisAlignment.center,
//     children: <Widget>[
//       Expanded(
//         child: TextField(
//           onChanged: (value) {
//             message = value;
//           },
//           decoration: kMessageTextFieldDecoration,
//         ),
//       ),
//       TextButton(
//         onPressed: () {
//           try {
//             _firestore.collection('messages').add({
//               'sender': loggedInUser.email,
//               'text': message,
//             });
//           } catch (e) {
//             debugPrint(e.toString());
//           }
//         },
//         child: Text(
//           'Send',
//           style: kSendButtonTextStyle,
//         ),
//       ),
//     ],
//   ),
// ),