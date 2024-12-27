import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../main.dart';
import '../widgets/bottom_navbar.dart';
import 'auth_screen.dart';


class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Splash süresi tamamlandıktan sonra yönlendirme
    Future.delayed(const Duration(seconds: 3), _navigateUser);
  }

  void _navigateUser() {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Kullanıcı oturum açmışsa BottomNavBar'a git
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => BottomNavBar()),
      );
    } else {
      // Kullanıcı oturum açmamışsa AuthScreen'e git
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book_rounded,
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              "Bookstagram",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}