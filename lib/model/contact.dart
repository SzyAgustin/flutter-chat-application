import 'package:flutter/material.dart';
// import 'package:chat_app/screens/chat.dart';
import '../main.dart';

class Contact extends StatelessWidget {
  Contact({this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue[200]),
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        child: Container(
          margin: const EdgeInsets.only(
            left: 10.0,
            right: 10.0,
          ),
          child: Text(email, style: TextStyle(fontWeight: FontWeight.w900)),
        ),
      ),
    );
  }
}
