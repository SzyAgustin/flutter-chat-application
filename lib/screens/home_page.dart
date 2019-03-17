import 'package:chat_application/screens/chat.dart';
import 'package:chat_application/screens/contacts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../handleDB/db_management.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Google sign in
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Color color = Colors.indigo[700];
  GoogleSignIn googleAuth = GoogleSignIn();
  String userName = "";
  bool signedIn = false;
  bool isLoading = false;
  FirebaseMessaging _messaging = FirebaseMessaging();
  // String loggedIn = "Not logged in";

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Chat Application"),
          actions: <Widget>[
            IconButton(
              icon: signedIn ? Icon(Icons.cancel) : Icon(Icons.person_add),
              onPressed: signedIn ? signOut : signInWithGoogle,
              tooltip: signedIn ? "Sign Out" : "Sign In",
            )
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              logedInName(),
              MaterialButton(
                disabledTextColor: Colors.black, //not working????
                disabledColor: Colors.grey,
                onPressed: signedIn ? goToContacts : null,
                child:
                    Text("My Contacts", style: TextStyle(color: Colors.white)),
                color: color,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        print(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('SGASDFGSDFGSDFGSDFHBSDFHBSFDGHBSFGHBDSGFBFX');
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => Chat(
        //             contactUid: message,
        //             contactName: nameOfContact,
        //           )),
        // );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void goToContacts() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Contacts()),
    );
  }

  void signOut() {
    FirebaseAuth.instance.signOut().then((_) {
      googleAuth.signOut();
      setState(() {
        DbManagement.user = null;
        userName = "";
        signedIn = false;
      });
    });
  }

  Widget logedInName() {
    if (isLoading) {
      return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue));
    }
    if (!signedIn) {
      return Text("Not logged in");
    }
    return Text(userName);
  }

  void signInWithGoogle() {
    setState(() {
      isLoading = true;
    });
    googleAuth.signIn().then((result) {
      result.authentication.then((googleKey) {
        AuthCredential cred = GoogleAuthProvider.getCredential(
          idToken: googleKey.idToken,
          accessToken: googleKey.accessToken,
        );
        FirebaseAuth.instance.signInWithCredential(cred).then((signedInUser) {
          storeUser(signedInUser);
          setState(() {
            DbManagement.user = signedInUser;
            userName = signedInUser.displayName;
            signedIn = true;
            isLoading = false;
          });
        });
      }).catchError((e) {
        print(e);
      });
    }).catchError((e) {
      print(e);
    });
  }

  void storeUser(FirebaseUser signedInUser) {
    Firestore.instance
        .collection('/users')
        .where('uid', isEqualTo: signedInUser.uid)
        .getDocuments()
        .then((docs) {
      if (docs.documents.length > 0) {
        _messaging.getToken().then((token) {
          Firestore.instance
              .document('/users/${docs.documents[0].documentID}')
              .updateData(
                  {'photoUrl': signedInUser.photoUrl, 'tokenId': token});
        });

        return;
      }
      Firestore.instance.collection('/users').add({
        'email': signedInUser.email,
        'uid': signedInUser.uid,
        'photoUrl': signedInUser.photoUrl,
        'displayName': signedInUser.displayName,
      });
    });
  }
}
