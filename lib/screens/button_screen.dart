import 'package:chat_application/screens/chat.dart';
import 'package:chat_application/screens/contacts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Google sign in
import 'package:google_sign_in/google_sign_in.dart';

class ButtonScreen extends StatefulWidget {
  @override
  _ButtonScreenState createState() => _ButtonScreenState();
}

class _ButtonScreenState extends State<ButtonScreen> {
  @override
  Color color = Colors.indigo[700];
  GoogleSignIn googleAuth = GoogleSignIn();
  String userName = "";
  bool loggedIn = false;
  // String loggedIn = "Not logged in";

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Application"),
        actions: <Widget>[],
        // elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 6.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            logedInName(),
            MaterialButton(
              onPressed: signInWithGoogle,
              child: Text("Sign in", style: TextStyle(color: Colors.white)),
              color: color,
            ),
            MaterialButton(
              disabledTextColor: Colors.black, //not working????
              disabledColor: Colors.grey,
              onPressed: loggedIn ? goToContacts : null,
              child: Text("My Contacts", style: TextStyle(color: Colors.white)),
              color: color,
            ),
            MaterialButton(
              disabledTextColor: Colors.black, //not working????
              disabledColor: Colors.grey,
              onPressed: loggedIn ? signOut : null,
              child: Text("Log Out", style: TextStyle(color: Colors.white)),
              color: color,
            ),
            FloatingActionButton(
              onPressed: onPressed,
              child: Icon(Icons.message),
              backgroundColor: color,
              tooltip: "Open chat view.",
            )
          ],
        ),
      ),
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
        userName = "";
        loggedIn = false;
      });
    });
  }

  Widget logedInName() {
    if (loggedIn) {
      return Text(userName);
    }
    return Text("Not logged in");
  }

  void onPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Chat()),
    );
  }

  void signInWithGoogle() {
    googleAuth.signIn().then((result) {
      result.authentication.then((googleKey) {
        AuthCredential cred = GoogleAuthProvider.getCredential(
          idToken: googleKey.idToken,
          accessToken: googleKey.accessToken,
        );
        storeUser(cred);
      }).catchError((e) {
        print(e);
      });
    }).catchError((e) {
      print(e);
    });
  }

  void storeUser(AuthCredential cred) {
    FirebaseAuth.instance.signInWithCredential(cred).then((signedInUser) {
      Firestore.instance
          .collection('/users')
          .where('uid', isEqualTo: signedInUser.uid)
          .getDocuments()
          .then((docs) {
        if (docs.documents.length > 0) {
          return;
        }
        Firestore.instance.collection('/users').add({
          'email': signedInUser.email,
          'uid': signedInUser.uid,
          'photoUrl': signedInUser.photoUrl,
        });
      });
      setState(() {
        userName = signedInUser.displayName;
        loggedIn = true;
      });
    });
  }
}
