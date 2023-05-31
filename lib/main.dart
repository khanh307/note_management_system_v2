import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_v2/cubits/drawer_cubit/drawer_cubit.dart';
import 'package:note_management_system_v2/cubits/signin_cubit/signin_cubit.dart';
import 'package:note_management_system_v2/home.dart';
import 'package:note_management_system_v2/models/user.dart';
import 'package:note_management_system_v2/screens/signin_screen.dart';
import 'package:note_management_system_v2/screens/signup_screen.dart';

void main() {
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
        home: HomeScreen(
          user: User(
              email: 'kyle@r2s.com.vn',
              password: '123',
              lastname: 'Le',
              firstname: 'Ky'),
        ));
  }
}
