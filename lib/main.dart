import 'package:flutter/material.dart';
import 'message_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(App(firebaseApp: app,));
}

class App extends StatelessWidget {
  const App({Key? key, required this.firebaseApp}) : super(key: key);
  final FirebaseApp firebaseApp;
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'fischerliste-7d23c',
      theme: ThemeData(primaryColor: const Color(0xFF3D814A)),
      home: MessageList(app: firebaseApp),
    );
  }
}
