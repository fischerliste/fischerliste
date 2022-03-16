import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:core';
import 'package:flutter/scheduler.dart';
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
  DatabaseReference? userRef;
  DateTime currentDate = DateTime.now();
  FirebaseDatabase database = FirebaseDatabase.instance;
  late String date;

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
    date = DateFormat('d.M.y').format(currentDate);
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        Navigator.of(context).push(showSigninPopup(context, auth)).then((value) {
          userRef = FirebaseDatabase.instance.ref().child(user.uid);
          prefs!.setString('UID', user.uid);
        });
      });
    }

    String weekNumber =
        ((int.parse(DateFormat('D').format(currentDate)) + 2.5) / 7).round().toString();
    String week = ' (KW ' + weekNumber + ')';
    date += week;

    return Scaffold(
        // drawer: Drawer(
        //   child: ListView(
        //     // Important: Remove any padding from the ListView.
        //     padding: EdgeInsets.zero,
        //     children: [
        //       DrawerHeader(
        //         decoration: const BoxDecoration(
        //           color: Colors.green,
        //         ),
        //         child: Text(
        //           'Drawer Header',
        //           style: TextStyle(
        //             color: Colors.grey[800],
        //             fontSize: 25,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //       ),
        //       ListTile(
        //         title: const Text('Item 1'),
        //         onTap: () {
        //           // Update the state of the app.
        //           // ...
        //         },
        //       ),
        //       const Divider(
        //         indent: 10,
        //         endIndent: 10,
        //       ),
        //       ListTile(
        //         title: const Text('Item 2'),
        //         onTap: () {
        //           // Update the state of the app.
        //           // ...
        //         },
        //       ),
        //       const Divider(
        //         indent: 10,
        //         endIndent: 10,
        //       ),
        //     ],
        //   ),
        // ),
        appBar: AppBar(
          title: Center(
            child: Row(
              children: [
                const Spacer(flex: 30),
                IconButton(
                  onPressed: () {
                    setState(() {
                      currentDate = currentDate.subtract(const Duration(days: 7));
                    });
                  },
                  icon: const Icon(Icons.chevron_left),
                ),
                const Spacer(flex: 1),
                Text(date),
                const Spacer(flex: 1),
                IconButton(
                  onPressed: () {
                    setState(() {
                      currentDate = currentDate.add(const Duration(days: 7));
                    });
                  },
                  icon: const Icon(Icons.chevron_right),
                ),
                const Spacer(flex: 30),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
          backgroundColor: Colors.green,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Column(
                  children: const [
                   Text('Montag'),
                    //ListView(),
                  ],
                ),
              ],
            ),
            Row(
              children: const [
                Text('Donnerstag'),
                //ListView(),
              ],
            ),
          ],
          mainAxisSize: MainAxisSize.max,
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
        SnackBar snackBar = const SnackBar(
          content: Text(
            'Email already in use!',
            style: TextStyle(fontSize: 20, color: Colors.white70),
          ),
        );
        ScaffoldMessenger.of(buildcontext).showSnackBar(snackBar);
        return false;
      }
      if (e.code == 'email-already-in-use') {
        SnackBar snackBar = const SnackBar(content: Text('Email already in use!'));
        ScaffoldMessenger.of(buildcontext).showSnackBar(snackBar);
        return false;
      } else if (e.code == 'weak-password') {
        SnackBar snackBar = const SnackBar(
            content: Text(
          'Weak password! Password must be at least 6 characters long!',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ));
        ScaffoldMessenger.of(buildcontext).showSnackBar(snackBar);
        return false;
      }
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return true;
    } else {
      return false;
    }

    ///@TODO: Add email verification!
    // if (user != null && !user.emailVerified) {
    //   var actionCodeSettings = ActionCodeSettings(
    //     url: 'https://fischerliste-7d23c.web.app/?email=${user.email}',
    //     androidPackageName: 'com.fischerliste.fischerliste',
    //     androidInstallApp: true,
    //     androidMinimumVersion: '8',
    //     iOSBundleId: 'com.fischerliste.fischerliste',
    //     handleCodeInApp: true,
    //   );
    //   user.sendEmailVerification(actionCodeSettings);
    //   return false;
    // } else if (user == null) {
    //   return false;
    // } else if (user.emailVerified) {
    //   return true;
    // } else {
    //   return false;
    // }
  }

  Future<bool> checkSignin() async {
    try {
      await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      e.message;
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return true;
    } else {
      return false;
    }

    ///@TODO: Add email verification!
    // if (user != null && !user.emailVerified) {
    //   var actionCodeSettings = ActionCodeSettings(
    //     url: 'https://fischerliste-7d23c.web.app/?email=${user.email}',
    //     androidPackageName: 'com.fischerliste.fischerliste',
    //     androidInstallApp: true,
    //     androidMinimumVersion: '8',
    //     iOSBundleId: 'com.fischerliste.fischerliste',
    //     handleCodeInApp: true,
    //   );
    //   user.sendEmailVerification(actionCodeSettings);
    //   return false;
    // } else if (user == null) {
    //   return false;
    // } else if (user.emailVerified) {
    //   return true;
    // } else {
    //   return false;
    // }
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
  const MessageList({Key? key}) : super(key: key);

  @override
  MessageListState createState() => MessageListState();
}
