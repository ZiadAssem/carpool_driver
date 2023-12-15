import 'package:carpool_driver/view/add_trips.dart';
import 'package:flutter/material.dart';
import '../firebase/authentication.dart';
import '../firebase/database.dart';

class SignInController {
  static signInUser(context, email, password) async {
    String networkError =
        '[firebase_auth/network-request-failed] A network error (such as timeout, interrupted connection or unreachable host) has occurred.';
    // Call the Firebase instance method here
    String? error = await Authentication.instance
        .signInWithEmailAndPassword(email, password);

    if (error == null) {
      //  final db = LocalDatabaseHelper();
      final user = {
        'email': email,
        'name': 'empty',
        'phoneNumber': 'empty',
      };

      Authentication.instance.isOnline = true;

      await DatabaseHelper.instance.getCurrentUser();

      // Navigate to the home page on success
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("SUCCESSFUL")));
      // Authentication.instance.getCurrentUser(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AddTripsPage()),
      );
    } else if (error == networkError) {
      // final db = LocalDatabaseHelper();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Network Error, please try again later")));
      //Test Case begin
      // final u = await db.getCurrentUser();
      // print(u);

      //Test Case end
      // if(await db.checkUser(email)){
      //         return 'User Found';
      // }
    } else {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
        ),
      );
      // Display error message on failure
    }
    return null;
  }
}
