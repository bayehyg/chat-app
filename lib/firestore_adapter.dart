import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreAdapter{
  User user;
  final _firestore = FirebaseFirestore.instance;

  FirestoreAdapter({required this.user});

  Future<List> initialFetch() async {
    final items = [];
    final snapshot = await _firestore.collection("conversations")
        .where("participantIds", arrayContains: "123456789")
        .get();
    items.addAll(snapshot.docs.map((doc) => doc.data()).toList());
    print(items.length);
    return items;
  }

  Stream<List<dynamic>> listenForChanges() async* {
    final controller = StreamController<List<dynamic>>();

    final items = <dynamic>[];

    _firestore.collection("conversations")
        .where("participantIds", arrayContains: "123456789")
        .snapshots()
        .listen((querySnapshot) {
      for (final change in querySnapshot.docChanges) {
        final conversation = change.doc.data()!;
        switch (change.type) {
          case DocumentChangeType.added:
            items.add(conversation);
            break;
          case DocumentChangeType.modified:
            final index = items.indexWhere((conv) => conv['id'] == conversation['id']);
            if (index != -1) {
              items[index] = conversation;
            }
            break;
          case DocumentChangeType.removed:
            final index = items.indexWhere((conv) => conv['id'] == conversation['id']);
            if (index != -1) {
              items.removeAt(index);
            }
            break;
        }
      }
      controller.sink.add(items);
    });

    yield* controller.stream;
  }
}