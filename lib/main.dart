import 'package:flutter/material.dart';
import 'package:todo_with_chat_app/auth/login_or_register.dart';
import 'package:todo_with_chat_app/pages/login_page.dart';
import 'package:todo_with_chat_app/pages/register_page.dart';
import 'package:todo_with_chat_app/themes/light_mode.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginOrRegister(),
      theme: lightMode,
    );
  }
}
