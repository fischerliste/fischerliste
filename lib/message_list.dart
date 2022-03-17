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
  ScrollController _moScrollController = ScrollController();
  ScrollController _tuScrollController = ScrollController();
  ScrollController _weScrollController = ScrollController();
  ScrollController _thScrollController = ScrollController();
  ScrollController _imScrollController = ScrollController();
  ScrollController _frScrollController = ScrollController();
  ScrollController _saScrollController = ScrollController();
  ScrollController _suScrollController = ScrollController();

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
                    padding: const EdgeInsets.fromLTRB(padding * 2, padding * 2, padding, padding),
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
                                  onPressed: () async {
                                    String? message = await _showMyDialog();
                                    print(message);
                                    if (message != null) {
                                      widget.messageDao.saveMessage(currentDate, 'Mo', message);
                                    }
                                  },
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
                                controller: _moScrollController,
                                query: widget.messageDao.getMessageQuery(currentDate, 'Mo'),
                                itemBuilder: (context, snapshot, animation, index) {
                                  dynamic json = snapshot.value;
                                  print(json);
                                  print(json.runtimeType);
                                  return ToDoEntry(json, index);
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
                      color: Colors.green,
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
                                  onPressed: () async {
                                    String? message = await _showMyDialog();
                                    print(message);
                                    if (message != null) {
                                      widget.messageDao.saveMessage(currentDate, 'Tu', message);
                                    }
                                  },
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
                                controller: _tuScrollController,
                                query: widget.messageDao.getMessageQuery(currentDate, 'Tu '),
                                itemBuilder: (context, snapshot, animation, index) {
                                  dynamic json = snapshot.value;
                                  print(json);
                                  print(json.runtimeType);
                                  return ToDoEntry(json, index);
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
                      color: Colors.green,
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
                                  onPressed: () async {
                                    String? message = await _showMyDialog();
                                    print(message);
                                    if (message != null) {
                                      widget.messageDao.saveMessage(currentDate, 'We', message);
                                    }
                                  },
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
                                controller: _weScrollController,
                                query: widget.messageDao.getMessageQuery(currentDate, 'We'),
                                itemBuilder: (context, snapshot, animation, index) {
                                  dynamic json = snapshot.value;
                                  print(json);
                                  print(json.runtimeType);
                                  return ToDoEntry(json, index);
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
                    padding: const EdgeInsets.fromLTRB(padding, padding * 2, padding * 2, padding),
                    child: Card(
                      color: Colors.green,
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
                                  onPressed: () async {
                                    String? message = await _showMyDialog();
                                    print(message);
                                    if (message != null) {
                                      widget.messageDao.saveMessage(currentDate, 'Im', message);
                                    }
                                  },
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
                                controller: _imScrollController,
                                query: widget.messageDao.getMessageQuery(currentDate, 'Im'),
                                itemBuilder: (context, snapshot, animation, index) {
                                  dynamic json = snapshot.value;
                                  print(json);
                                  print(json.runtimeType);
                                  return ToDoEntry(json, index);
                                },
                              ),
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
                    padding: const EdgeInsets.fromLTRB(padding * 2, padding, padding, padding * 2),
                    child: Card(
                      color: Colors.green,
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
                                  onPressed: () async {
                                    String? message = await _showMyDialog();
                                    print(message);
                                    if (message != null) {
                                      widget.messageDao.saveMessage(currentDate, 'Th', message);
                                    }
                                  },
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
                                controller: _thScrollController,
                                query: widget.messageDao.getMessageQuery(currentDate, 'Th'),
                                itemBuilder: (context, snapshot, animation, index) {
                                  dynamic json = snapshot.value;
                                  print(json);
                                  print(json.runtimeType);
                                  return ToDoEntry(json, index);
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
                    padding: const EdgeInsets.fromLTRB(padding, padding, padding, padding * 2),
                    child: Card(
                      color: Colors.green,
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
                                  onPressed: () async {
                                    String? message = await _showMyDialog();
                                    print(message);
                                    if (message != null) {
                                      widget.messageDao.saveMessage(currentDate, 'Fr', message);
                                    }
                                  },
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
                                controller: _frScrollController,
                                query: widget.messageDao.getMessageQuery(currentDate, 'Fr'),
                                itemBuilder: (context, snapshot, animation, index) {
                                  dynamic json = snapshot.value;
                                  print(json);
                                  print(json.runtimeType);
                                  return ToDoEntry(json, index);
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
                    padding: const EdgeInsets.fromLTRB(padding, padding, padding, padding * 2),
                    child: Card(
                      color: Colors.green,
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
                                  onPressed: () async {
                                    String? message = await _showMyDialog();
                                    print(message);
                                    if (message != null) {
                                      widget.messageDao.saveMessage(currentDate, 'Sa', message);
                                    }
                                  },
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
                                controller: _saScrollController,
                                query: widget.messageDao.getMessageQuery(currentDate, 'Sa'),
                                itemBuilder: (context, snapshot, animation, index) {
                                  dynamic json = snapshot.value;
                                  print(json);
                                  print(json.runtimeType);
                                  return ToDoEntry(json, index);
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
                    padding: const EdgeInsets.fromLTRB(padding, padding, padding * 2, padding * 2),
                    child: Card(
                      color: Colors.green,
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
                                  onPressed: () async {
                                    String? message = await _showMyDialog();
                                    print(message);
                                    if (message != null) {
                                      widget.messageDao.saveMessage(currentDate, 'Su', message);
                                    }
                                  },
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
                                controller: _suScrollController,
                                query: widget.messageDao.getMessageQuery(currentDate, 'Su'),
                                itemBuilder: (context, snapshot, animation, index) {
                                  dynamic json = snapshot.value;
                                  print(json);
                                  print(json.runtimeType);
                                  return ToDoEntry(json, index);
                                },
                              ),
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
      ),
    );
  }

  Future<String?> _showMyDialog() async {
    TextEditingController textcontroller = TextEditingController();
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Neuen Eintrag erstellen'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextField(
                  controller: textcontroller,
                  decoration: const InputDecoration(labelText: 'Titel'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop(textcontroller.text);
              },
            ),
          ],
        );
      },
    );
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
  void saveMessage(DateTime date, String dayKey, String message) {
    int weekNumber = ((int.parse(DateFormat('D').format(date)) + 2.5) / 7).round();
    User? user = FirebaseAuth.instance.currentUser;
    int year = int.parse(DateFormat('y').format(date));
    if (user != null) {
      FirebaseDatabase.instance
          .ref()
          .child('/${user.uid}/$year/$weekNumber/$dayKey')
          .push()
          .set(message);
    }
  }

  Query getMessageQuery(DateTime datetime, String dayKey) {
    int weekNumber = ((int.parse(DateFormat('D').format(datetime)) + 2.5) / 7).round();
    User? user = FirebaseAuth.instance.currentUser;
    int year = int.parse(DateFormat('y').format(datetime));
    if (user != null) {
      print(FirebaseDatabase.instance.ref().child('/${user.uid}/$year/$weekNumber/$dayKey'));
      return FirebaseDatabase.instance.ref().child('/${user.uid}/$year/$weekNumber/$dayKey');
    }
    return FirebaseDatabase.instance.ref().child('NullUser');
  }
}

class ToDoEntry extends StatelessWidget {
  final String message;
  final int index;

  ToDoEntry(this.message, this.index);

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
