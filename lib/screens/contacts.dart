import 'package:chat_application/handleDB/db_management.dart';
import 'package:chat_application/model/contact.dart';
import 'package:chat_application/screens/chat.dart';
import './home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Contacts extends StatefulWidget {
  @override
  Contacts();
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  // final List<Contact> contacts = <Contact>[];
  QuerySnapshot contacts;

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Contacts"),
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              child: contactsList(),
            ),
          ],
        ),
      ),
    );
  }

  void openChatWith(String uid, String nameOfContact) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Chat(
                contactUid: uid,
                contactName: nameOfContact,
              )),
    );
  }

  Widget contactsList() {
    if (contacts == null) {
      return Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)));
    }
    return ListView.builder(
      itemCount: contacts.documents.length,
      padding: EdgeInsets.all(16.0),
      itemBuilder: (_, int i) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue[200]),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: ListTile(
            title: Text(contacts.documents[i].data['email']),
            subtitle: Text(contacts.documents[i].data['uid']),
            onTap: () => openChatWith(contacts.documents[i].data['uid'],
                contacts.documents[i].data['displayName']),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    Firestore.instance
        .collection('/users')
        // .where('uid', isEqualTo: widget.user.uid)
        .getDocuments()
        .then((docs) {
      setState(() {
        contacts = docs;
      });
    });
    super.initState();
  }
}
