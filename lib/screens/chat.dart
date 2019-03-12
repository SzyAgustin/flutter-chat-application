import 'package:chat_application/main.dart';
import 'package:chat_application/model/msg.dart';
import 'package:chat_application/screens/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../handleDB/db_management.dart';

class Chat extends StatefulWidget {
  @override
  Chat({
    this.contactUid,
    this.contactName,
  });
  final String contactUid;
  final String contactName;
  State createState() => ChatWindow();
}

class ChatWindow extends State<Chat> with TickerProviderStateMixin {
  // final List<Msg> messages = <Msg>[];
  final TextEditingController _textController = TextEditingController();
  bool _isWriting = false;

  Stream<QuerySnapshot> messages;

  @override
  Widget build(BuildContext ctx) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.contactName),
          elevation: Theme.of(ctx).platform == TargetPlatform.iOS ? 0.0 : 6.0,
        ),
        body: Column(children: <Widget>[
          Flexible(
            child: _msgsList(),
          ),
          _buildComposer(),
        ]),
      ),
    );
  }

  Widget _msgsList() {
    if (messages != null) {
      return StreamBuilder<QuerySnapshot>(
        stream: messages,
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            padding: EdgeInsets.all(16.0),
            reverse: true,
            itemBuilder: (context, i) {
              return Msg(
                txt: snapshot.data.documents[snapshot.data.documents.length-1-i].data['message'],
                senderUid: snapshot.data.documents[snapshot.data.documents.length-1-i].data['senderUid'],
              );
            },
          );
        },
      );
    } else {
      return Text("Loading, please wait...");
    }
  }

  @override
  void initState() {
    messages = DbManagement()
        .getMessagesBetween(DbManagement.user.uid, widget.contactUid);
    super.initState();
  }

  Widget textField() {
    return Flexible(
      child: Container(
        height: 40.0,
        padding: EdgeInsets.only(left: 10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.black12)),
        child: Center(
          child: TextField(
            controller: _textController,
            onChanged: (String txt) {
              setState(() {
                _isWriting = txt.length > 0;
              });
            },
            onSubmitted: _submitMsg,
            decoration: InputDecoration.collapsed(hintText: "Write a message"),
          ),
        ),
      ),
    );
  }

  Widget _buildComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 9.0),
      child: Row(
        children: <Widget>[
          textField(),
          Container(
            margin: EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
            width: 50.0,
            height: 50.0,
            child: FloatingActionButton(
              backgroundColor: _isWriting ? Colors.green : Colors.grey,
              child: Icon(Icons.send),
              onPressed:
                  _isWriting ? () => _submitMsg(_textController.text) : null,
            ),
          ),
        ],
      ),
    );
  }

  void _submitMsg(String txt) {
    FirebaseUser user = DbManagement.user;
    _textController.clear();
    setState(() {
      _isWriting = false;
    });
    Firestore.instance.collection('/messages').add({
      // 'senderUid': user.uid,
      'userOneUid': user.uid.hashCode < widget.contactUid.hashCode
          ? user.uid
          : widget.contactUid,
      'userTwoUid': user.uid.hashCode < widget.contactUid.hashCode
          ? widget.contactUid
          : user.uid,
      'senderUid': user.uid,
      'message': txt,
      'date': DateTime.now(),
    }).catchError((e) {
      print(e);
    });

    // Msg msg = Msg(
    //   txt: txt,
    //   animationController: AnimationController(
    //       vsync: this, duration: Duration(milliseconds: 200)),
    // );
    // setState(() {
    //   messages.insert(0, msg);
    // });
    // msg.animationController.forward();
  }

  // @override
  // void dispose() {
  //   for (Msg msg in messages) {
  //     msg.animationController.dispose();
  //   }
  //   super.dispose();
  // }
}
