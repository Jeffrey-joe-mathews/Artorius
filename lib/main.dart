import 'package:artorius/auth/auth.dart';
import 'package:artorius/auth/login_or_register.dart';
import 'package:artorius/firebase_options.dart';
import 'package:artorius/pages/login_page.dart';
import 'package:artorius/pages/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: LoginPage(),
      // home: RegisterPage(),
      // home: LoginOrRegister(),
      home: AuthPage(),
    );
  }
}