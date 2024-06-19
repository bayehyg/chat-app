import 'package:chat_app/UserManager.dart';
import 'package:chat_app/components/bottomNavigation.dart';
import 'package:chat_app/components/custom_search_bar.dart';
import 'package:chat_app/firestore_adapter.dart';
import 'package:chat_app/screens/addUserPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/User.dart';
import '../components/conversations_card.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';

  const ChatScreen({super.key});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  var itemsMaps = <String, dynamic>{};
  late FirestoreAdapter firestore;
  late User loggedInUser;
  late String message;
  late final ChatUser myUser;
  bool notifications = false; // controller for notifications

  @override
  void initState() {
    super.initState();
    firestore = FirestoreAdapter(); // TODO: add a user once done with testing
    getCurrentUserAndFetch();
    // TODO: change the hardcoded user
    // initialized the singleton class UserManager

    firestore.listenForConversationChanges(itemsMaps).listen((snapshot) {
      print("whats going on: ${snapshot.toString()}");
      setState(() {
        itemsMaps = snapshot;
      });
    });
  }

  int getUnreadCount(List<Map<String, dynamic>> messages, DateTime userLastTime,
      String userId) {
    int count = 0;
    for (var val in messages) {
      if (DateTime.fromMillisecondsSinceEpoch(val['timestamp'].seconds * 1000)
              .isAfter(userLastTime) &&
          val['userId'] != userId) ++count;
    }
    return count;
  }

  void getCurrentUserAndFetch() async {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
    } else {
      Navigator.pop(context);
      return;
    }
    // firestore.fetchUser(loggedInUser.uid).then((value) {
    //   myUser = value;
    //   UserManager.instance.initializeUser(loggedInUser, value);
    //   return value;
    // });
    itemsMaps = await firestore.initialFetch();
    print(itemsMaps.length);
    itemsMaps.forEach((key, val) {
      print("key: $key");
      firestore.listenForMessageChanges(key).listen((snapshot) {
        setState(() {});
      });
    });
  }

  /// loads the coversation list from the database
  Future<ListView> loadConversations(
      Map<String, dynamic> convosMap, bool isjustNotifications) async {
    final items = [];
    await Future.forEach(convosMap.entries,
        (MapEntry<String, dynamic> entry) async {
      myUser = UserManager
          .instance.currentChatUser!; // the singleton user i.e the owner
      Map<String, dynamic> thisParticipant = entry.value['participants'][
          0]; // the participant info in the database currently initialized to the first one for search
      for (dynamic participant in entry.value['participants']) {
        if (myUser.id.toString() == participant['userId']) {
          thisParticipant = participant;
          break;
        }
      }
      int unread = getUnreadCount(
          await firestore.fetchMessages(entry.key),
          DateTime.fromMillisecondsSinceEpoch(
              thisParticipant['lastReadTimeStamp'].seconds * 1000),
          myUser.id);
      List<ChatUser> users = [];
      for (String id in entry.value['participantIds']) {
        if (id != myUser.id) {
          final user = await firestore.fetchUser(id);
          users.add(user);
        }
      }
      if (isjustNotifications && unread < 1) return;
      items.add({
        'convoId': entry.key,
        'users': users,
        'value': entry.value,
        'unread': unread
      });
    });

    items.sort((a, b) {
      final aTimestamp = DateTime.fromMillisecondsSinceEpoch(
          a['value']['lastMessage']['timestamp'].seconds * 1000);
      final bTimestamp = DateTime.fromMillisecondsSinceEpoch(
          b['value']['lastMessage']['timestamp'].seconds * 1000);
      return aTimestamp.compareTo(bTimestamp);
    });
    final ListView conversationList;
    try {
      conversationList = ListView.builder(
        reverse: true,
        itemCount: items.length,
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 16),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          String? formattedDate;
          DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
              items[index]['value']['lastMessage']['timestamp'].seconds * 1000);
          DateFormat dateFormat = DateFormat('hh:mm a');
          formattedDate = dateFormat.format(dateTime);

          return Column(
            children: [
              const Divider(
                indent: 10,
                endIndent: 10,
              ),
              ConversationList(
                groupName: items[index]['value']['groupName'],
                users: items[index]["users"],
                conversationId: items[index]['convoId'],
                messageText: items[index]['value']['lastMessage']['text'],
                imageUrl: '',
                time: formattedDate ?? '',
                isMessageRead: items[index]['unread'] > 0 ? false : true,
                unRead: items[index]['unread'],
              )
            ],
          );
        },
      );
    } catch (e) {
      print(e);
      return ListView();
    }

    return conversationList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddUserPage.id);
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: CustomBottomNav(
        onNotificationsSelected: () {
          setState(() {
            notifications = true;
          });
        },
        onHomeSelected: () {
          setState(() {
            notifications = false;
          });
        },
      ),
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(CupertinoIcons.gear),
              onPressed: () {
                //Implement logout functionality
              }),
        ],
        title: Text('CodeBand',
            style: kLogoTextStyle.copyWith(
                fontSize: 27, color: const Color(0xfff1f1f1))),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const CustomSearchBar(),
            FutureBuilder<ListView>(
              future: loadConversations(itemsMaps, notifications),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return snapshot.data!;
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
