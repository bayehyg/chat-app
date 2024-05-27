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
  void initState()  {
    super.initState();
    getCurrentUser();
    firestore = FirestoreAdapter(); // TODO: add a user once done with testing
    firestore.listenForChanges().listen((snapshot) {
      setState(() {
        if(snapshot.isNotEmpty){
          itemsMap.addAll(snapshot);
          // snapshot.forEach((key, value) {
          //   itemsMap.add()
          // });
        }
      });
    });
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
    }
  }


  /**
   * loads the coversation list from the database
   */
  Future<ListView> loadConversations() async {

    itemsMap = await firestore.initialFetch();
    final items = [];
    ChatUser tempUser;
    await Future.forEach(itemsMap.entries, (MapEntry<String, dynamic> entry) async {
      final user = await firestore.fetchUser(entry.value['participantIds'][1]);
      items.add({
        'user': user,
        'value': entry.value
      });
    });

    final conversationList = ListView.builder(
      reverse: true,
      itemCount: items.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 16),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index){
        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(items[index]['value']['lastTimestamp'].seconds * 1000);
        DateFormat dateFormat = DateFormat('hh:mm a');
        String formattedDate = dateFormat.format(dateTime);
        return Column(
          children: [
            Divider(indent: 10, endIndent: 10,),
            ConversationList(
                user: items[index]["user"],
                messageText: items[index]['value']['lastMessage'],
                imageUrl: '',
                time: formattedDate,
                isMessageRead: true//items[index]['isMessageRead'],
            )
          ],
        );
      },
    );
    return conversationList;
  }


  @override
  Widget build(BuildContext context) {

    //print('56: ' + items.length.toString());
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
            FutureBuilder<ListView>(
              future: loadConversations(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator()
                  );
                }
                else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                else if (snapshot.hasData) {
                  return snapshot.data!;
                }
                else {
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