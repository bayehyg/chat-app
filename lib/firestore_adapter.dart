import 'dart:async';

import 'package:chat_app/components/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreAdapter{
  User? user;
  final _firestore = FirebaseFirestore.instance;

  FirestoreAdapter({ this.user});

  /**
   * This method fetches a user from firestore and returns the user as a ChatUser object
   *
   * @param id: the users id to search for.
   */
  Future<ChatUser> fetchUser(String id) async {
    DocumentReference docRef = _firestore.collection('users').doc(id);

    DocumentSnapshot docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      // Cast the data to a Map<String, dynamic>
      Map<String, dynamic> userData = docSnapshot.data() as Map<String, dynamic>;
      return ChatUser.fromMap(userData);
    } else {
      // Handle the case where the document does not exist
      throw Exception('User not found');
    }
  }

  Future<Map<String, dynamic>> initialFetch() async {
    final items = <String, dynamic>{};
    final snapshot = await _firestore.collection("conversations")
        .where("participantIds", arrayContains: "123456789")
        .get();

    for (var doc in snapshot.docs) {
      var data = doc.data();
      data['conversationId'] = doc.id;
      List convos = [];
      items[doc.id] = doc;
    }
    return items;
  }


  Stream<Map<String, dynamic>> listenForChanges() async* {
    final controller = StreamController<Map<String, dynamic>>();

    final items = <String, dynamic>{};

    _firestore.collection("conversations")
        .where("participantIds", arrayContains: "123456789")
        .snapshots()
        .listen((querySnapshot) {
      for (final change in querySnapshot.docChanges) {
        final conversation = change.doc.data()!;
        final conversationId = change.doc.id; // Assuming 'id' is the document ID
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

    yield* controller.stream;
  }
}