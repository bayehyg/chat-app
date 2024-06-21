import 'dart:async';

import 'package:avatar_stack/positions.dart';
import 'package:chat_app/UserManager.dart';
import 'package:chat_app/components/custom_avatar.dart';
import 'package:chat_app/firestore_adapter.dart';
import 'package:flutter/material.dart';
import 'package:avatar_stack/avatar_stack.dart';
import 'package:random_avatar/random_avatar.dart';
import '../components/User.dart';
import '../components/conversations_card.dart';

class AddUserPage extends StatefulWidget {
  static String id = 'addUserPage';
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  late FirestoreAdapter firestore;
  late ChatUser myUser;
  late TextEditingController _userIdController = TextEditingController();
  List<ChatUser> users = [
    // ChatUser(
    //     id: "1234",
    //     avatarName: "avatarName",
    //     email: "email",
    //     firstName: "firstName",
    //     lastName: "lastName",
    //     lastSeen: DateTime.now())
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //myUser = UserManager.instance.currentChatUser!;
    firestore = FirestoreAdapter();
    myUser = UserManager.instance.currentChatUser!;
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    return emailRegex.hasMatch(email);
  }

  Future<void> _addUser() async {
    final String emailOrUserName = _userIdController.text.trim();
    if (emailOrUserName == myUser.email || emailOrUserName == myUser.id) {
      return;
    }
    ChatUser searchUser;
    try {
      if (isValidEmail(emailOrUserName)) {
        searchUser = await firestore.fetchUserByEmail(emailOrUserName);
      } else {
        searchUser = await firestore.fetchUser(emailOrUserName);
      }
      setState(() {
        users.add(searchUser);
        _userIdController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Row(
          children: [
            Icon(
              Icons.check,
              color: Colors.green,
            ),
            Text('User added successfully!'),
          ],
        )),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          'User not found',
          style: TextStyle(color: Color(0xff9a0625)),
        )),
      );
    }
  }

  void onPressed() async {
    String? groupName;
    if (users.isEmpty) {
      SnackBar(
          content: Text(
        'Please add users first!',
        style: TextStyle(color: Color(0xff9a0625)),
      ));
      return;
    }
    if (users.length > 1) {
      final Completer<String> groupNameCompleter = Completer<String>();

      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 4,
              child: TextField(
                onSubmitted: (value) {
                  if (value.isEmpty) {
                    const SnackBar(
                      content: Text(
                        'Please add users first!',
                        style: TextStyle(color: Color(0xff9a0625)),
                      ),
                    );
                  } else {
                    groupNameCompleter.complete(value);
                  }
                },
                decoration: InputDecoration(
                  label: Text("Enter group name"),
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  suffixIcon: Text('OK',
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 20)),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.grey.shade100)),
                ),
              ),
            );
          });
      groupName = await groupNameCompleter.future;
    }
    users.add(myUser);
    String convoId = await firestore.createConversation(users, groupName);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Conversation Created'),
              content: Container(
                height: MediaQuery.of(context).size.height / 5,
                //width: MediaQuery.of(context).size.height * 4 / 5,
                child: ConversationList(
                  groupName: groupName,
                  users: users,
                  conversationId: convoId,
                  messageText: '',
                  imageUrl: '',
                  time: '',
                  isMessageRead: true,
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    _userIdController = TextEditingController();
    final settings = RestrictedPositions(
      layoutDirection: LayoutDirection.vertical,
      maxCoverage: -0.1,
      minCoverage: 0.2,
      align: StackAlign.left,
    );
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: onPressed,
      ),
      appBar: AppBar(
        title: Text('Add User'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 3,
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    controller: _userIdController,
                    decoration: InputDecoration(
                      labelText: 'Email or User id',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _addUser,
                    child: Text('Add'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          const Divider(),
          //if (users.length > 0)
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                for (int n = 0; n < users.length; n++)
                  Column(
                    children: [
                      CustomAvatar(user: users[n]),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
