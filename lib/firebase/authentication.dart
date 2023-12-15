import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../classes_updated/user_class.dart' as U;
import '../view/signin.dart';
import 'database.dart';
import 'sign-up-failure.dart';


class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String currentUserId;
  bool isOnline = false;

  Authentication._();
  static final Authentication _instance = Authentication._();
  static Authentication get instance => _instance;

  isUserSignedIn() {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  Future<String?> createUserWithEmailAndPassword(String fullName,
      String emailAddress, String password, String phoneNumber) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: emailAddress, password: password);
      U.User user =
          U.User(name: fullName, email: emailAddress, phoneNumber: phoneNumber);

      DatabaseHelper.instance.addUserToDb(user.toJson());
      currentUserId = emailAddress.replaceAll("@eng.asu.edu.eg", "");

      return null; // Return null for success
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      return ex.message; // Return the error message for failure
    } catch (e) {
      return e.toString(); // Return a string representation of other exceptions
    }
  }

  signInWithEmailAndPassword(emailAddress, password) async {
    try {
      final credential = await _auth
          .signInWithEmailAndPassword(email: emailAddress, password: password)
          .then((value) =>
              currentUserId = emailAddress.replaceAll("@eng.asu.edu.eg", ""));
      print("Current User *********************************");
      print(currentUserId);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        print("Error is ${e.toString()}");
      }
return e.toString();
    }
  }

  getCurrentUser(context) async {
    final User? user = _auth.currentUser;
    final uid = user!.uid;
    return uid;
  }

  signOutUser(context) async {
    await _auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SignInScreen()));
  }

  deleteAccount(context) async {
    await _auth.currentUser!.delete();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SignInScreen()));
  }
}
