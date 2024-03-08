import 'package:finalproject/pages/login_page.dart';
import 'package:finalproject/pages/register_page.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool ShowLogin = true;

  void toggleChanges() {
    setState(() {
      ShowLogin = !ShowLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (ShowLogin) {
      return LoginPage(onTap: toggleChanges);
    } else {
      return RegisterPage(onTap: toggleChanges);
    }
  }
}
