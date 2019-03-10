import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DbManagement {
  static FirebaseUser user;

  getMessagesBetween(String uidOne, String uidTwo) {
    // Stream<QuerySnapshot>messages = Firestore.instance
    //     .collection('/messages')
    //     .where('userUidOne', isEqualTo: uidOne)
    //     .where('userUidTwo', isEqualTo: uidTwo)
    //     .getDocuments()
    //     .then((docs) {
    //   Firestore.instance
    //       .collection('/messages')
    //       .where('userUidTwo', isEqualTo: uidOne)
    //       .where('userUidOne', isEqualTo: uidTwo)
    //       .getDocuments()
    //       .then((docs2) {
    //     docs.documents.addAll(docs2.documents);
    //     docs.documents.sort((a,b){
    //       //have to sort by date in some way
    //       // " a.data['date'] > b.data['date'] " doesn't work
    //     });
    //   });
    // }).asStream();

    Stream<QuerySnapshot> sent = Firestore.instance
        .collection('/messages')
        .where('userOneUid', isEqualTo: uidOne)
        .where('userTwoUid', isEqualTo: uidTwo)
        .snapshots();

    Stream<QuerySnapshot> recieved = Firestore.instance
        .collection('/messages')
        .where('userOneUid', isEqualTo: uidTwo)
        .where('userTwoUid', isEqualTo: uidOne)
        .snapshots();
    Stream<QuerySnapshot> messages =  StreamGroup.merge([sent, recieved]).asBroadcastStream();
    print(messages.length);
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
