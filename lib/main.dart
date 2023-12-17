import 'package:carpool_driver/classes_updated/triprequest_class.dart';
import 'package:carpool_driver/controller/signin_controller.dart';
import 'package:carpool_driver/firebase/authentication.dart';
import 'package:carpool_driver/firebase/database.dart';
import 'package:carpool_driver/view/add_trips.dart';
import 'package:carpool_driver/view/signin.dart';
import 'package:carpool_driver/view/trip_requests.dart';
import 'package:carpool_driver/view/view_trips.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Authentication.instance.signInWithEmailAndPassword('testdriver@eng.asu.edu.eg','test1234');
  await DatabaseHelper.instance.getCurrentUser();

   runApp(const MainApp());
}

 testCase() async {
  final databaseReference = DatabaseHelper.instance.reference;
  String currentUserID = 'test'; // Replace with the actual user key

  // Query the specific user
  DatabaseEvent userSnapshot =
      await databaseReference.child('Users/$currentUserID').once();
  Map<dynamic, dynamic>? userData =
      userSnapshot.snapshot.value as Map<dynamic, dynamic>?;

  if (userData != null && userData['driverTrips'] != null) {
    // Retrieve driverTrips
    Map<dynamic, dynamic> driverTrips = userData['driverTrips'];
    List<String> routeKeys = [];
    List<Map<String, dynamic>> tripDataList = [];

    for (var routeKey in driverTrips.keys) {
      if (driverTrips[routeKey] == 'awaiting') {
        routeKeys.add(routeKey);
        print('trip key $routeKey');
      }

  
    }

    for (var routeKey in routeKeys) {
      // Perform additional queries for each route
       DatabaseEvent event = await databaseReference.child('Routes').orderByChild(routeKey).once();
       print(event.snapshot.value);
    Map<String, dynamic> tripData = {routeKey: event.snapshot.value};
    tripDataList.add(tripData);
    }
  } else {
    print('User not found or missing driverTrips data.');
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ViewTrips(),
    );
  }
}
