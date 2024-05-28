import 'package:chat_app/components/User.dart';
import 'package:chat_app/screens/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:random_avatar/random_avatar.dart';

class ConversationList extends StatefulWidget{
  ChatUser user;
  String conversationId;
  String messageText;
  String imageUrl;
  String time;
  bool isMessageRead;
  ConversationList({super.key, required this.user, required this.conversationId,required this.messageText,required this.imageUrl,required this.time,required this.isMessageRead});
  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  final List<types.Message> _messages = [];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return ChatPage(
            conversationId: widget.conversationId,
            user: types.User(
              id: widget.user.id,
              firstName: widget.user.firstName,
              lastName: widget.user.lastName,
              lastSeen: widget.user.lastSeen.millisecond
            ),
          );
        }));
      },
      child: Container(
        padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                RandomAvatar(widget.user.avatarName, height: 50, width: 50),
                  SizedBox(width: 16,),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.user.getFullName(), style: TextStyle(fontSize: 16),),
                          SizedBox(height: 6,),
                          Text(widget.messageText,style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(widget.time,style: TextStyle(fontSize: 12,fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),),
          ],
        ),
      ),
    );
  }
}