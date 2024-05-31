import 'package:chat_app/UserManager.dart';
import 'package:chat_app/components/bottomNavigation.dart';
import 'package:chat_app/components/custom_search_bar.dart';
import 'package:chat_app/firestore_adapter.dart';
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
  var itemsMap = <String, dynamic>{};
  late FirestoreAdapter firestore;
  late User loggedInUser;
  late String message;

  @override
  void initState() {
    super.initState();
    firestore = FirestoreAdapter(); // TODO: add a user once done with testing
    getCurrentUserAndFetch();
    var thisUser = firestore.fetchUser("123456789").then((value) {
      UserManager.instance.initializeUser(null, value);
      return value;
    }); // TODO: change the hardcoded user
    // initialized the singleton class UserManager

    firestore.listenForConversationChanges(itemsMap).listen((snapshot) {
      setState(() {
        if (snapshot.isNotEmpty) {}
      });
    });
  }

  int getUnreadCount(List<Map<String, dynamic>> messages, DateTime userLastTime,
      String userId) {
    int count = 0;
    messages.forEach((val) {
      if (DateTime.fromMillisecondsSinceEpoch(val['timestamp'].seconds * 1000)
              .isAfter(userLastTime) &&
          val['userId'] != userId) ++count;
    });
    return count;
  }

  void getCurrentUserAndFetch() async {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
    }
    itemsMap = await firestore.initialFetch();
    print(itemsMap.length);
    itemsMap.forEach((key, val) {
      print("key: $key");
      firestore.listenForMessageChanges(key).listen((snapshot) {
        setState(() {});
      });
    });
  }

  /// loads the coversation list from the database
  Future<ListView> loadConversations() async {
    final items = [];
    ChatUser tempUser;
    await Future.forEach(itemsMap.entries,
        (MapEntry<String, dynamic> entry) async {
      ChatUser myUser = UserManager
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
      final user = await firestore.fetchUser(entry.value['participantIds'][1]);
      items.add({
        'convoId': entry.key,
        'user': user,
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
    final conversationList = ListView.builder(
      reverse: true,
      itemCount: items.length,
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 16),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
            items[index]['value']['lastMessage']['timestamp'].seconds * 1000);
        DateFormat dateFormat = DateFormat('hh:mm a');
        String formattedDate = dateFormat.format(dateTime);
        return Column(
          children: [
            const Divider(
              indent: 10,
              endIndent: 10,
            ),
            ConversationList(
              user: items[index]["user"],
              conversationId: items[index]['convoId'],
              messageText: items[index]['value']['lastMessage']['text'],
              imageUrl: '',
              time: formattedDate,
              isMessageRead: items[index]['unread'] > 0 ? false : true,
              unRead: items[index]['unread'],
            )
          ],
        );
      },
    );
    return conversationList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNav(),
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
              future: loadConversations(),
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
