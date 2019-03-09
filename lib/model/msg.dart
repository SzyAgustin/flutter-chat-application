import 'package:flutter/material.dart';
// import 'package:chat_app/screens/chat.dart';
import '../main.dart';

class Msg extends StatelessWidget {
  Msg({this.txt, this.animationController});
  final String txt;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            listOfMsgs(context),
          ],
        ),
      ),
    );
  }

  Widget listOfMsgs(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue[200]),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          senderName(),
          Container(
            margin: const EdgeInsets.all(5),
            child: Text(txt),
          ),
        ],
      ),
    );
  }

  Widget senderName() {
    if (1==2) return null;
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
