import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'data/message_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class MessageListState extends State<MessageList> {
  String? uid;
  SharedPreferences? prefs;
  FirebaseAuth auth =
      FirebaseAuth.instanceFor(app: Firebase.app('fischerliste'));

  @override
  void initState() {
    SharedPreferences.getInstance().then((SharedPreferences? value) {
      prefs = value;
      uid = prefs!.getString('UID');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (uid == null) {
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        Navigator.of(context).push(showSigninPopup(context)).then((value) {
          prefs!.setString('UID', uid!);
          return uid = value;
        });
      });
    }

    return Scaffold(
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
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
                const Spacer(flex: 30),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.chevron_left),
                ),
                const Spacer(flex: 1),
                const Text('Fischerliste'),
                const Spacer(flex: 1),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.chevron_right),
                ),
                const Spacer(flex: 30),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
          backgroundColor: Colors.green,
        ),
        body: const Center(
          child: Icon(Icons.add_to_queue_sharp),
        ));
  }
}

DialogRoute showSigninPopup(BuildContext buildcontext) {
  TextEditingController controller = TextEditingController();
  signupDialog() {
    return "UID";
  }

  bool checkSignin() {
    return true;
  }

  return DialogRoute(
    builder: (context) {
      return AlertDialog(
        title: const Text("Please sign in!"),
        content: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'Passwort'),
              obscureText: true,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                String id = signupDialog();
                Navigator.pop(context, id);
              },
              child: const Text("Registrieren")),
          TextButton(
              onPressed: () {
                if (checkSignin()) {
                  Navigator.pop(context);
                }
              },
              child: const Text("Anmelden")),
        ],
      );
    },
    context: buildcontext,
  );
}

class MessageList extends StatefulWidget {
  MessageList({Key? key}) : super(key: key);

  final messageDao = MessageDao();

  @override
  MessageListState createState() => MessageListState();
}
