import 'package:carpool_driver/classes_updated/trip_class.dart';
import 'package:carpool_driver/firebase/authentication.dart';
import 'package:flutter/material.dart';

import '../firebase/database.dart';

class AddTripController {
  static void addTrip(
      context, route, destination, gate, date, int price, int seats) {
    if (destination == 'toCampus') {
      destination = 'Campus';
    } else {
      destination = 'Home';
    }
    final userName = Authentication.instance.currentUserId;

    print("User ID is $userName");
    destination = destination.replaceAll('to', '');
    route = route.replaceAll(' ', '');
    print('Updated Route is $route');

    final updatedRoute = '$route' 'Route';
    final updatedDestination = '$destination' + 'Trips';
    print('Updated Route is $updatedRoute');
    print('Updated Destination is $updatedDestination');
    final generatedKey = DatabaseHelper.instance.reference
        .child("Routes")
        .child(updatedRoute)
        .child(updatedDestination)
        .push()
        .key;
    final trip = Trip(
        tripKey: generatedKey!,
        gate: gate,
        driverId: userName,
        numberOfSeatsLeft: seats,
        price: price,
        status: 'awaiting',
        date: date,
        route: route,
        destination: destination);

    try {
      DatabaseHelper.instance.addTripToDb(
          generatedKey, updatedRoute, updatedDestination, trip.toJson());

      DatabaseHelper.instance.addTripToDriver(
        generatedKey,
        trip.toJson(),
      );
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      return;
      // TODO
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Trip Added Successfully"),
      ),
    );
  }
}
