import 'dart:async';
import 'dart:developer';

import 'package:chat_app/UserManager.dart';
import 'package:chat_app/components/User.dart';
import 'package:chat_app/screens/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreAdapter {
  static User? user = UserManager.instance.currentUser;
  final _firestore = FirebaseFirestore.instance;

  /// This method fetches a user from firestore and returns the user as a ChatUser object
  ///
  /// @param id: the users id to search for.
  Future<ChatUser> fetchUser(String id) async {
    DocumentReference docRef = _firestore.collection('users').doc(id);

    DocumentSnapshot docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      // Cast the data to a Map<String, dynamic>
      Map<String, dynamic> userData =
          docSnapshot.data() as Map<String, dynamic>;
      return ChatUser.fromMap(id, userData);
    } else {
      // Handle the case where the document does not exist
      throw Exception('User not found');
    }
  }

  Future<ChatUser> fetchUserByEmail(String email) async {
    final docRef = _firestore
        .collection('users')
        .where("email", isEqualTo: email)
        .limit(1);

    final docSnapshot = await docRef.get();
    if (docSnapshot.docs.isNotEmpty) {
      // Cast the data to a Map<String, dynamic>
      final userDocument = docSnapshot.docs.first;
      return ChatUser.fromMap(userDocument.id, userDocument.data());
    } else {
      // Handle the case where the document does not exist
      throw Exception('User not found');
    }
  }

  Future<String> createConversation(
      List<ChatUser> users, String? groupName) async {
    List<Map<String, dynamic>> data = [];
    List<String> participantIds = [];
    for (ChatUser person in users) {
      participantIds.add(person.id);
      data.add({
        'lastReadTimeStamp': Timestamp.now(),
        'name': person.getFullName(),
        'userId': person.id
      });
    }
    Map<String, dynamic> last = {
      'seen': true,
      'text': '',
      'timestamp': Timestamp.now(),
      'userId': ""
    };
    DocumentReference conversationRef =
        await _firestore.collection('conversations').add({
      'groupName': groupName,
      'participants': data, // Array field of participants
      'participantIds': participantIds,
      'lastMessage': last
    });
    conversationRef.collection("messages");
    return conversationRef.id;
  }

  Future<Map<String, dynamic>> initialFetch() async {
    final items = <String, dynamic>{};
    final snapshot = await _firestore
        .collection("conversations")
        .where("participantIds", arrayContains: "123456789")
        .get();

    for (var doc in snapshot.docs) {
      var data = doc.data();
      data['conversationId'] = doc.id;
      items[doc.id] = doc;
    }
    return items;
  }

  /// takes in the the document id and fetches the messages related to that conversation
  /// @param conversationId id
  Future<List<Map<String, dynamic>>> fetchMessages(
      String conversationId) async {
    final snapshot = await _firestore
        .collection("conversations")
        .doc(conversationId)
        .collection("messages")
        .get();
    List<Map<String, dynamic>> allDocuments =
        snapshot.docs.map((doc) => doc.data()).toList();
    return allDocuments;
  }

  Future<void> updateConversationLastRead(String convoId, String userId) async {
    final docRef = _firestore.collection('conversations').doc(convoId);
    final snapshot = await docRef.get();
    final data = snapshot.data() as Map<String, dynamic>;
    final userMaps = data['participants'] as List<dynamic>;
    final userMap = userMaps.firstWhere(
      (map) => map['userId'] == userId,
      orElse: () => null,
    );
    if (userMap != null) {
      // Update the desired field in the userMap
      userMap['lastReadTimeStamp'] = Timestamp.now();
      await docRef.update({'participants': userMaps});
      log('Document updated successfully.');
    } else {
      log('User map not found.');
    }
  }

  void sendMessage(String message, String conversationId, String userId) async {
    final conversationDoc =
        _firestore.collection("conversations").doc(conversationId);
    final newMessageDoc = conversationDoc.collection("messages").doc();
    Map<String, dynamic> data = {
      'seen': false,
      'text': message,
      'timestamp': Timestamp.now(),
      'userId': userId
    };
    newMessageDoc.set(data);
    await conversationDoc.update({
      'lastMessage': data,
    });
  }

  Stream<Map<String, dynamic>> listenForConversationChanges(
      Map<String, dynamic> items) async* {
    final controller = StreamController<Map<String, dynamic>>();
    try {
      _firestore
          .collection("conversations")
          .where("participantIds", arrayContains: user!.uid)
          .snapshots()
          .listen((querySnapshot) {
        for (final change in querySnapshot.docChanges) {
          final conversation = change.doc.data()!;
          final conversationId = change.doc.id;
          switch (change.type) {
            case DocumentChangeType.added:
              items[conversationId] = conversation;
              break;
            case DocumentChangeType.modified:
              if (items.containsKey(conversationId)) {
                items[conversationId] = conversation;
              }
              break;
            case DocumentChangeType.removed:
              items.remove(conversationId);
              break;
          }
        }
        controller.sink.add(items);
      });
    } catch (e) {
      log(e.toString());
    }
    yield* controller.stream;
  }

  Stream<Map<String, dynamic>> listenForMessageChanges(
      String conversationId) async* {
    final controller = StreamController<Map<String, dynamic>>();

    final items = <String, dynamic>{};

    try {
      _firestore
          .collection("conversations")
          .doc(conversationId)
          .collection("messages")
          .snapshots()
          .listen((querySnapshot) {
        for (final change in querySnapshot.docChanges) {
          final conversation = change.doc.data()!;
          final conversationId = change.doc.id;
          switch (change.type) {
            case DocumentChangeType.added:
              items[conversationId] = conversation;
              break;
            case DocumentChangeType.modified:
              if (items.containsKey(conversationId)) {
                items[conversationId] = conversation;
              }
              break;
            case DocumentChangeType.removed:
              items.remove(conversationId);
              break;
          }
        }
        controller.sink.add(items);
      });
    } catch (e) {
      log(e.toString());
    }
    yield* controller.stream;
  }
}
