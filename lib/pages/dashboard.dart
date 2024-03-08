import 'package:finalproject/pages/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/pages/dashboardData.dart';
import 'package:finalproject/pages/notes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  void _navbottombar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }

  final List<Widget> _pages = [DashData(), Notes(), Profile()];

  void confirmLogout() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade300,
            content: Container(
              height: 75,
              width: 90,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Do you really want to logout?',
                    style: GoogleFonts.bebasNeue(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontSize: 20,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        onPressed: () => signUserOut(),
                        color: Color.fromRGBO(0, 168, 181, 1),
                        child: Text('YES'),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      MaterialButton(
                        onPressed: () => Navigator.of(context).pop(),
                        color: Color.fromRGBO(238, 15, 15, 1),
                        child: Text('NO'),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: _pages[_selectedIndex],
          appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Image(
                image: AssetImage('lib/images/appname.png'),
                width: 300,
                height: 50,
              ),
              actions: [
                IconButton(onPressed: confirmLogout, icon: Icon(Icons.logout))
              ],
              centerTitle: true,
              flexibleSpace: Container(
                  decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(0, 168, 181, 1),
                    Color.fromARGB(255, 0, 0, 0)
                  ],
                  stops: [0, 1],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ))),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color.fromRGBO(0, 168, 181, 1),
                Color.fromARGB(255, 0, 0, 0)
              ],
              stops: [0, 1],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
              child: GNav(
                onTabChange: (index) => setState(() => _selectedIndex = index),
                selectedIndex: _selectedIndex,
                backgroundColor: Colors.transparent,
                color: Color.fromARGB(255, 255, 255, 255),
                activeColor: Color.fromRGBO(0, 168, 181, 1),
                tabBackgroundColor: Color.fromRGBO(88, 88, 88, 1),
                tabBackgroundGradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(0, 168, 181, 1),
                    Color.fromARGB(255, 0, 0, 0)
                  ],
                  stops: [0, 1],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
                iconSize: 20,
                gap: 20,
                padding: EdgeInsets.all(20),
                tabs: const [
                  GButton(
                    icon: Icons.dashboard,
                    text: 'Dashboard',
                  ),
                  GButton(
                    icon: Icons.sticky_note_2,
                    text: 'Notes',
                  ),
                  GButton(
                    icon: Icons.account_circle,
                    text: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
