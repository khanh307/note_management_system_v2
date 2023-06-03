import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:note_management_system_v2/models/shared_preferences.dart';
import 'package:note_management_system_v2/screens/signin_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPreferencesManager.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SignInHome());
  }
}
