import 'package:chat_application/handleDB/db_management.dart';
import 'package:flutter/material.dart';
// import 'package:chat_app/screens/chat.dart';
import '../main.dart';

class Msg extends StatelessWidget {
  Msg({this.txt, this.senderUid});
  final String txt;
  final senderUid;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      child: Wrap(
        spacing: 8.0, // gap between adjacent chips
        runSpacing: 4.0, // gap between lines
        direction: Axis.horizontal,
        alignment: senderUid != DbManagement.user.uid
            ? WrapAlignment.start
            : WrapAlignment.end,
        children: <Widget>[
          msg(context),
        ],
      ),
    );
  }

  BoxDecoration boxDecorationBasedOnSender() {
    if (senderUid != DbManagement.user.uid) {
      return BoxDecoration(
        border: Border.all(color: Colors.blue[200]),
        color: Colors.blue[50],
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: new Offset(3, 3),
            blurRadius: 3,
          ),
        ],
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      );
    } else {
      return BoxDecoration(
        border: Border.all(color: Colors.lightGreen[400]),
        color: Colors.lightGreen[50],
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: new Offset(3, 3),
            blurRadius: 3,
          ),
        ],
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      );
    }
  }

  Widget msg(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 2.0, bottom: 2, right: 5, left: 5),
      decoration: boxDecorationBasedOnSender(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(5),
            child: Text(txt),
          ),
        ],
      ),
    );
  }

  Widget senderName() {
    return Container(
      margin: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
      ),
      child:
          Text(defaultUserName, style: TextStyle(fontWeight: FontWeight.w900)),
    );
  }
}
