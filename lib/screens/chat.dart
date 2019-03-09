import 'package:chat_application/main.dart';
import 'package:chat_application/model/msg.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  @override
  State createState() => ChatWindow();
}

class ChatWindow extends State<Chat> with TickerProviderStateMixin {
  final List<Msg> messages = <Msg>[];
  final TextEditingController _textController = TextEditingController();
  bool _isWriting = false;

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Application"),
        elevation: Theme.of(ctx).platform == TargetPlatform.iOS ? 0.0 : 6.0,
      ),
      body: Column(children: <Widget>[
        Flexible(
          child: ListView.builder(
            itemBuilder: (_, int index) => messages[index],
            itemCount: messages.length,
            reverse: true,
            padding: EdgeInsets.all(16.0),
          ),
        ),
        _buildComposer(),
      ]),
    );
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
      // decoration: Theme.of(context).platform == TargetPlatform.iOS
      //     ? BoxDecoration(
      //         border: Border(top: BorderSide(color: Colors.brown)))
      //     : null,
    );
  }

  void _submitMsg(String txt) {
    _textController.clear();
    setState(() {
      _isWriting = false;
    });
    Msg msg = Msg(
      txt: txt,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 200)),
    );
    setState(() {
      messages.insert(0, msg);
    });
    msg.animationController.forward();
  }

  @override
  void dispose() {
    for (Msg msg in messages) {
      msg.animationController.dispose();
    }
    super.dispose();
  }
}
