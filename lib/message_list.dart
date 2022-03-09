import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'data/message_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class MessageListState extends State<MessageList> {
  MessageListState({required this.app});
  FirebaseApp app;
  String? uid;
  SharedPreferences? prefs;
  late FirebaseAuth auth;
  UserCredential? credential;

  @override
  void initState() {
    auth = FirebaseAuth.instanceFor(app: app);
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
        Navigator.of(context)
            .push(showSigninPopup(context, auth))
            .then((value) {
          credential = value;
          prefs!.setString('UID', uid!);
          return uid = "1234test";
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

DialogRoute showSigninPopup(BuildContext buildcontext, FirebaseAuth auth) {
  UserCredential? credential;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool createUser() {
    try {
      print("------------------------");
      auth
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((UserCredential? value) {
        print("------------------------");
        credential = value;
        print("------------------------");

      });
    } on Exception catch(exception){
      print("________________________");
      print(exception);
    } on Error catch (error) {
      print("========================");
      print(error);
    }
    return true;
  }

  bool checkSignin() {
    try {
      auth
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) {
        print(value);
      });
    } catch (exception) {
      print(exception);
    }
    return true;
  }

  return DialogRoute(
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text("Bitte anmelden!"),
        content: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Passwort'),
              obscureText: true,
            ),
          ],
          mainAxisSize: MainAxisSize.min,
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                createUser();
                Navigator.pop(context);
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
  MessageList({Key? key, required this.app}) : super(key: key);
  final FirebaseApp app;
  final messageDao = MessageDao();

  @override
  MessageListState createState() => MessageListState(app: app);
}
