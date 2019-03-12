import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DbManagement {
  static FirebaseUser user;

  getMessagesBetween(String uidOne, String uidTwo) {
    Stream<QuerySnapshot> messages = Firestore.instance
        .collection('/messages')
        .where('userOneUid',
            isEqualTo: uidOne.hashCode < uidTwo.hashCode ? uidOne : uidTwo)
        .where('userTwoUid',
            isEqualTo: uidOne.hashCode < uidTwo.hashCode ? uidTwo : uidOne)
        .snapshots();

    return messages;
  }

  deleteMessage(id) {
    Firestore.instance
        .collection('/messages')
        .document(id)
        .delete()
        .catchError((e) {
      print(e);
    });
  }
}
