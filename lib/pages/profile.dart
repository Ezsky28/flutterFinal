import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Color.fromRGBO(106, 107, 107, 1),
          Color.fromARGB(255, 0, 0, 0)
        ],
        stops: [0, 1],
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade300.withOpacity(.5),
              ),
              width: 350.0,
              height: 500.0,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 200,
                    color: Color.fromRGBO(0, 168, 181, 1),
                  ),
                  Text(
                    'Email: ${user!.email}',
                    style: GoogleFonts.bebasNeue(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                  MaterialButton(onPressed: signUserOut)
                ],
              )),
        ),
      ),
    );
  }
}
