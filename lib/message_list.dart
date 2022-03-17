import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:core';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class MessageListState extends State<MessageList> {
  static const double padding = 8.0;
  MessageListState();
  FirebaseApp app = Firebase.app();
  String? uid;
  SharedPreferences? prefs;
  FirebaseAuth auth = FirebaseAuth.instanceFor(app: Firebase.app());
  UserCredential? credential;
  DateTime currentDate = DateTime.now();
  FirebaseDatabase database = FirebaseDatabase.instance;
  late String date;
  ScrollController _scrollController = ScrollController();

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
    int weekNumber = ((int.parse(DateFormat('D').format(currentDate)) + 2.5) / 7).round();
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print('hello');
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        Navigator.of(context).push(showSigninPopup(context, auth)).then((value) {
          user = FirebaseAuth.instance.currentUser;
          prefs!.setString('UID', user!.uid);
          print(user);
          setState(() {});
          // SchedulerBinding.instance?.scheduleForcedFrame();
        });
      });
    }

    String week = ' (KW ' + weekNumber.toString() + ')';
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
          backgroundColor: Colors.lightGreen,
        ),
        backgroundColor: Colors.grey[100],
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(padding * 2, padding * 2, padding, padding),
                      child: Card(
                        color: Colors.green,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ListTile(
                                title: Center(
                                  child: Text(
                                    'Montag',
                                    style: TextStyle(fontSize: 26.0, color: Colors.grey[800]),
                                  ),
                                ),
                                trailing: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.grey[800],
                                    )),
                              ),
                              Expanded(
                                flex: 1,
                                child: FirebaseAnimatedList(
                                  key: UniqueKey(),
                                  shrinkWrap: true,
                                  controller: _scrollController,
                                  query: widget.messageDao.getMessageQuery(currentDate, 'Mo'),
                                  itemBuilder: (context, snapshot, animation, index) {
                                    dynamic json = snapshot.value;
                                    print(json);
                                    print(json.runtimeType);
                                    final message = Message.fromJson(json);
                                    return MessageWidget(message.text);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(padding, padding * 2, padding, padding),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ListTile(
                                title: Center(
                                  child: Text(
                                    'Dienstag',
                                    style: TextStyle(fontSize: 26.0, color: Colors.grey[800]),
                                  ),
                                ),
                                trailing: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.grey[800],
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(padding, padding * 2, padding, padding),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ListTile(
                                title: Center(
                                  child: Text(
                                    'Mittwoch',
                                    style: TextStyle(fontSize: 26.0, color: Colors.grey[800]),
                                  ),
                                ),
                                trailing: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.grey[800],
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(padding, padding * 2, padding * 2, padding),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ListTile(
                                title: Center(
                                  child: Text(
                                    'Merk ich mir!',
                                    style: TextStyle(fontSize: 26.0, color: Colors.grey[800]),
                                  ),
                                ),
                                trailing: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.grey[800],
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(padding * 2, padding, padding, padding * 2),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ListTile(
                                title: Center(
                                  child: Text(
                                    'Donnerstag',
                                    style: TextStyle(fontSize: 26.0, color: Colors.grey[800]),
                                  ),
                                ),
                                trailing: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.grey[800],
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(padding, padding, padding, padding * 2),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ListTile(
                                title: Center(
                                  child: Text(
                                    'Freitag',
                                    style: TextStyle(fontSize: 26.0, color: Colors.grey[800]),
                                  ),
                                ),
                                trailing: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.grey[800],
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(padding, padding, padding, padding * 2),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ListTile(
                                title: Center(
                                  child: Text(
                                    'Samstag',
                                    style: TextStyle(fontSize: 26.0, color: Colors.grey[800]),
                                  ),
                                ),
                                trailing: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.grey[800],
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(padding, padding, padding * 2, padding * 2),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ListTile(
                                title: Center(
                                  child: Text(
                                    'Sonntag',
                                    style: TextStyle(fontSize: 26.0, color: Colors.grey[800]),
                                  ),
                                ),
                                trailing: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.grey[800],
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          mainAxisSize: MainAxisSize.max,
        ));
  }
}

DialogRoute showSigninPopup(BuildContext buildcontext, FirebaseAuth auth) {
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
  MessageList({Key? key}) : super(key: key);
  final messageDao = MessageDao();

  @override
  MessageListState createState() => MessageListState();
}

class MessageDao {
  final DatabaseReference _messagesRef = FirebaseDatabase.instance.ref().child('messages');

  void saveMessage(Message message) {
    _messagesRef.push().set(message.toJson());
  }

  Query getMessageQuery(DateTime datetime, String dateKey) {
    int weekNumber = ((int.parse(DateFormat('D').format(datetime)) + 2.5) / 7).round();
    User? user = FirebaseAuth.instance.currentUser;
    int year = int.parse(DateFormat('y').format(datetime));
    if (user != null) {
      return FirebaseDatabase.instance.ref().child('/${user.uid}/$year/$weekNumber/$dateKey');
    }
    return FirebaseDatabase.instance.ref().child('NullUser');
  }
}

class MessageWidget extends StatelessWidget {
  final String message;

  MessageWidget(this.message);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 1, top: 5, right: 1, bottom: 2),
      child: Card(
        child: ListTile(
          title: Text(message),
        ),
      ),
    );
  }
}

class Message {
  final String text;

  Message(this.text);

  Message.fromJson(String json) : text = json;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'text': text,
      };
}
