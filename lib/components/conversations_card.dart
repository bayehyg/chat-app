import 'package:chat_app/UserManager.dart';
import 'package:chat_app/components/User.dart';
import 'package:chat_app/screens/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:random_avatar/random_avatar.dart';

class ConversationList extends StatefulWidget {
  List<ChatUser> users;
  String? groupName;
  String conversationId;
  String messageText;
  String imageUrl;
  String time;
  bool isMessageRead;
  int? unRead;
  ConversationList(
      {super.key,
      required this.users,
      required this.conversationId,
      required this.messageText,
      required this.imageUrl,
      required this.time,
      required this.isMessageRead,
      this.unRead,
      this.groupName});
  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  late final ChatUser? _user;
  late final String avatarName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user = UserManager.instance.currentChatUser;
    avatarName = _user!.id != widget.users[0].id
        ? widget.users[0].avatarName
        : widget.users[1].avatarName;
  }

  List<types.User> getUsers() {
    List<types.User> chatUsers = [];

    for (ChatUser temp in widget.users) {
      chatUsers.add(types.User(
          id: temp.id,
          firstName: temp.firstName,
          lastName: temp.lastName,
          lastSeen: temp.lastSeen.millisecond));
    }

    return chatUsers;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatPage(
              conversationId: widget.conversationId,
              groupName: widget.groupName,
              avatarName: widget.users[0].avatarName,
              users: getUsers());
        }));
      },
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  widget.groupName == null
                      ? RandomAvatar(avatarName, height: 50, width: 50)
                      : CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Text(widget.groupName![0]),
                        ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.groupName == null
                                ? widget.users[0].getFullName()
                                : widget.groupName!,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            widget.messageText,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: widget.isMessageRead
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  widget.time,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: widget.isMessageRead
                          ? FontWeight.bold
                          : FontWeight.normal),
                ),
                SizedBox(
                  height: 10,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    if (!widget.isMessageRead)
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        child: Center(
                          child: Text(
                            widget.unRead!
                                .toString(), // Replace with the actual unread count
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
