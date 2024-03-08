import 'package:finalproject/pages/dashboard.dart';
//import 'package:finalproject/pages/home_page.dart';
import 'package:finalproject/pages/login_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthCheck extends StatelessWidget {
  AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //logged in
          if (snapshot.hasData) {
            return Dashboard();
          }

          //not logged in
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
