import 'dart:ui';

import 'package:finalproject/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final conpasswordController = TextEditingController();

  Future<void> signUserup() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildSignInIndicator(),
    );

    try {
      if (passwordController.text == conpasswordController.text) {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        Navigator.pop(context);

        User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
          final GoogleSignInAuthentication? gAuth = await gUser?.authentication;

          if (gUser != null && gAuth != null) {
            final gCredential = GoogleAuthProvider.credential(
                accessToken: gAuth.accessToken, idToken: gAuth.idToken);

            await currentUser.linkWithCredential(gCredential);
          }
        }
      } else {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              backgroundColor: Color.fromRGBO(0, 168, 181, 1),
              title: Center(
                child: Text(
                  'Passwords don\'t match!',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        );
      }
    } catch (e) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color.fromRGBO(0, 168, 181, 1),
            title: Center(
              child: Text(
                'Error: ${e.toString()}',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildSignInIndicator() {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Signing In...'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        colors: [Color.fromRGBO(0, 168, 181, 1), Color.fromARGB(255, 0, 0, 0)],
        stops: [0, 1],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('lib/images/applogo.png', height: 180),

                    const SizedBox(
                      height: 50,
                    ),

                    Container(
                      height: 460,
                      width: 400,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255)
                              .withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Hello new student let\'s create an account for you! ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            //email field
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: TextFormField(
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: const Icon(Icons.email),
                                      prefixIconColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => states.contains(
                                                      MaterialState.focused)
                                                  ? const Color.fromRGBO(
                                                      0, 168, 181, 1)
                                                  : const Color.fromRGBO(
                                                      0, 0, 0, 1)),
                                      hintText: 'Email',
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            //password field
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: TextFormField(
                                    controller: passwordController,
                                    keyboardType: TextInputType.emailAddress,
                                    textAlignVertical: TextAlignVertical.center,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: const Icon(Icons.lock),
                                      prefixIconColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => states.contains(
                                                      MaterialState.focused)
                                                  ? const Color.fromRGBO(
                                                      0, 168, 181, 1)
                                                  : const Color.fromRGBO(
                                                      0, 0, 0, 1)),
                                      hintText: 'Password',
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: TextFormField(
                                    controller: conpasswordController,
                                    keyboardType: TextInputType.emailAddress,
                                    textAlignVertical: TextAlignVertical.center,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: const Icon(Icons.lock),
                                      prefixIconColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => states.contains(
                                                      MaterialState.focused)
                                                  ? const Color.fromARGB(
                                                      255, 15, 175, 15)
                                                  : const Color.fromRGBO(
                                                      0, 0, 0, 1)),
                                      hintText: 'Confirm Password',
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 5,
                            ),

                            //login button
                            Container(
                              padding: const EdgeInsets.all(20),
                              child: ElevatedButton(
                                onPressed: signUserup,
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(20),
                                    backgroundColor:
                                        const Color.fromRGBO(0, 168, 181, 1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
                                child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'REGISTER',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ]),
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            const Row(
                              children: [
                                Expanded(
                                    child: Divider(
                                  thickness: 1,
                                  color: Color.fromARGB(255, 190, 190, 190),
                                )),
                                Text(
                                  'Or continue with',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Expanded(
                                    child: Divider(
                                  thickness: 1,
                                  color: Color.fromARGB(255, 190, 190, 190),
                                ))
                              ],
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            GestureDetector(
                              onTap: () => AuthService().signInWithGoogle(),
                              child: Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromRGBO(
                                            0, 168, 181, 1)),
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white),
                                child: Image.asset('lib/images/google.png',
                                    height: 65),
                              ),
                            ),
                          ]),
                    ),

                    const SizedBox(
                      height: 35,
                    ),

                    //register
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already a student?',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            ' Login now',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
