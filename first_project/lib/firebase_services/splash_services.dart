import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/ui/auth/login_screen.dart';
import 'package:first_project/ui/firestore/firestore_list_screen.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      Timer(
          const Duration(seconds: 4),
          () => (Navigator.push(context,
              MaterialPageRoute(builder: (context) => FireStoreScreen()))));
    } else {
      Timer(
          const Duration(seconds: 4),
          () => (Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()))));
    }
  }
}
