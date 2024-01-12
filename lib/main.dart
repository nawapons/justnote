import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:justnote/api/firebase_message.dart';
import 'package:justnote/screen/main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Mitr'),
        home: const MainPage());
  }
}
