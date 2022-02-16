import 'dart:ffi';

import 'message_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'data/message.dart';
import 'data/message_dao.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class MessageListState extends State<MessageList> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() async {
    final String UID = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return signinDialog();
        }) as String;
    super.initState();
  }

  signupDialog() {
    return "UID";
  }

  signinDialog() {
    bool checkSignin() {
      return true;
    }

    return AlertDialog(
      title: Text("Please sign in!"),
      content: Icon(Icons.account_box_outlined),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              String ID = signupDialog();
              if (ID != null) {
                Navigator.pop(context, ID);
              }
            },
            child: Text("Registrieren")),
        TextButton(
            onPressed: () {
              if (checkSignin()) {
                Navigator.pop(context);
              }
            },
            child: Text("Anmelden")),
      ],
    );
  }

  _showOpenDialog(_) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return signinDialog();
        }) as String;
  }

  @override
  Widget build(BuildContext context) {
    //WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
                child: Text(
                  'Drawer Header',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                title: const Text('Item 1'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              const Divider(
                indent: 10,
                endIndent: 10,
              ),
              ListTile(
                title: const Text('Item 2'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              const Divider(
                indent: 10,
                endIndent: 10,
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Center(
            child: Row(
              children: [
                Spacer(flex: 30),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.chevron_left),
                ),
                Spacer(flex: 1),
                Text('Fischerliste'),
                Spacer(flex: 1),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.chevron_right),
                ),
                Spacer(flex: 30),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
          backgroundColor: Colors.green,
        ),
        body: Center(
          child: Icon(Icons.add_to_queue_sharp),
        ));
  }

  void _sendMessage() {
    if (_canSendMessage()) {
      final message = Message(_messageController.text, DateTime.now());
      widget.messageDao.saveMessage(message);
      _messageController.clear();
      setState(() {});
    }
  }

  Widget _getMessageList() {
    return Expanded(
      child: FirebaseAnimatedList(
        controller: _scrollController,
        query: widget.messageDao.getMessageQuery(),
        itemBuilder: (context, snapshot, animation, index) {
          final json = snapshot.value as Map<dynamic, dynamic>;
          final message = Message.fromJson(json);
          return MessageWidget(message.text, message.date);
        },
      ),
    );
  }

  bool _canSendMessage() => _messageController.text.isNotEmpty;

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }
}

class MessageList extends StatefulWidget {
  MessageList({Key? key}) : super(key: key);

  final messageDao = MessageDao();

  @override
  MessageListState createState() => MessageListState();
}
