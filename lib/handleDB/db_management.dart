import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

class DbManagement {
  static FirebaseUser user;
  // static FirebaseMessaging;
  // static FirebaseMessaging msg = FirebaseMessaging();

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

  getStoredPhotoStream(){
    return Firestore.instance
        .collection('/users')
        .where('uid',
            isEqualTo: user.uid)
        .snapshots().map((snap) => Image.network(snap.documents[0].data['photoUrl']));
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

  Future<DocumentSnapshot> getStoredUser() async {
    QuerySnapshot users = await Firestore.instance
        .collection('/users')
        .where('uid', isEqualTo: user.uid)
        .getDocuments();

    return users.documents[0];
}

  Future<String> getUrlImageFromUser() async {
    if (getStoredUser() == null){
      return null;
    }
    var storedUser = await getStoredUser();
    return storedUser.data['photoUrl'];
  }

  Future<Image> getImageFromUser() async {
    String url = await getUrlImageFromUser();
    return Image.network(url);
  }

  void updateUrlImageToUser(String url)async {
    DocumentSnapshot storedUser = await getStoredUser();
      Firestore.instance
              .document('/users/${storedUser.documentID}')
              .updateData({'photoUrl': url});
  }

  void storeNewUser(FirebaseUser signedInUser, FirebaseMessaging messaging) {
    messaging.getToken().then((token) {
      Firestore.instance.collection('/users').add({
        'email': signedInUser.email,
        'uid': signedInUser.uid,
        'photoUrl': signedInUser.photoUrl,
        'displayName': signedInUser.displayName,
        'tokenId': token,
      });
    });
  }

  void storeUser(FirebaseUser signedInUser, FirebaseMessaging messaging) {
    Firestore.instance
        .collection('/users')
        .where('uid', isEqualTo: signedInUser.uid)
        .getDocuments()
        .then((docs) {
      if (docs.documents.length > 0) {
        messaging.getToken().then((token) {
          Firestore.instance
              .document('/users/${docs.documents[0].documentID}')
              .updateData({'tokenId': token});
        });
        return;
      }

      
      storeNewUser(signedInUser, messaging);
    });
  }
}
