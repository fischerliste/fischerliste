import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'data/message_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class MessageListState extends State<MessageList> {
  MessageListState();
  FirebaseApp app = Firebase.app();
  String? uid;
  SharedPreferences? prefs;
  FirebaseAuth auth = FirebaseAuth.instanceFor(app: Firebase.app());
  UserCredential? credential;

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
        Navigator.of(context).push(showSigninPopup(context, auth)).then((value) {
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

  Future<bool> createUser() async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        SnackBar snackBar = const SnackBar(content: Text('Email already in use!'));
        ScaffoldMessenger.of(buildcontext).showSnackBar(snackBar);
        return false;
      }
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
    return true;
  }

  Future<bool> checkSignin() async {
    try {
      await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        SnackBar snackBar = const SnackBar(content: Text('Email already in use!'));
        ScaffoldMessenger.of(buildcontext).showSnackBar(snackBar);
        return false;
      }
      print('Failed with error code: ${e.code}');
      print(e.message);
    } finally {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        var actionCodeSettings = ActionCodeSettings(
          url: 'https://fischerliste-7d23c.web.app/?email=${user.email}',
          androidPackageName: 'com.fischerliste.fischerliste',
          androidInstallApp: true,
          androidMinimumVersion: '8',
          iOSBundleId: 'com.fischerliste.fischerliste',
          handleCodeInApp: true,
        );

        user.sendEmailVerification(actionCodeSettings);
      }
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
                createUser().then((value) {
                  if (value) {
                    Navigator.pop(context);
                  }
                });
              },
              child: const Text("Registrieren")),
          TextButton(
              onPressed: () {
                checkSignin().then((value) {
                  if (value) {
                    Navigator.pop(context);
                  }
                });
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

  @override
  MessageListState createState() => MessageListState();
}
