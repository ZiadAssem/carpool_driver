import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import '../classes_updated/routes_class.dart';
import '../classes_updated/triprequest_class.dart';
import '../classes_updated/user_class.dart';
import '../classes_updated/trip_class.dart';
import 'authentication.dart';

class DatabaseHelper {
  final DatabaseReference reference = FirebaseDatabase.instance.ref();
  // late String currentUserId;
  late User currentUser;

  DatabaseHelper._();
  static final DatabaseHelper _instance = DatabaseHelper._();
  static DatabaseHelper get instance => _instance;

  // check database
  Future checkDatabase() async {
    try {
      await reference.get().timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw TimeoutException("Time out 1111"),
          );
      print("Connected to database");
    } catch (error) {
      print("Error connecting to database: $error");
      return false;
    }
  }

  // Add a new data to the database
  Future<void> addData(String path, Map<String, dynamic> data) async {
    await reference.child(path).push().set(data);
  }

  // Update an existing data in the database
  Future<void> updateData(String path, Map<String, dynamic> data) async {
    await reference.child(path).update(data);
  }

  // Remove a data from the database
  Future<void> removeData(String path) async {
    await reference.child(path).remove();
  }

  // Retrieve data from the database
  Future<DatabaseEvent> getData(String path) async {
    return await reference.child(path).once();
  }

  Future<List<Route>> getRoutesFromDb() async {
    print("test         1");
    final event = await reference.child('Routes').once()
        // .timeout(
        //       const Duration(seconds: 60),
        //       onTimeout: () => throw TimeoutException("Time out"),
        //     )
        ;
    print("test         2");

    Map<dynamic, dynamic> values =
        event.snapshot.value as Map<dynamic, dynamic>;

    List<Route> routes = [];
    values.forEach((key, value) {
      routes.add(Route(location: value['location']));
    });
    routes.toSet().toList();
    return routes;
  }

  Future<List<List<Trip>>> getTripsFromDb(String path) async {
    path = '${path.replaceAll(" ", "")}Route';
    path = "Routes/$path";
    print('path: $path');

    List<List<Trip>> trips = [];
    List<Trip> campusTripsDb = [];
    List<Trip> homeTripsDb = [];

    try {
      final event = await reference.child(path).once().timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException("Time out"),
          );

      Map<dynamic, dynamic>? values =
          event.snapshot.value as Map<dynamic, dynamic>?;

      print("values: $values");

      if (values != null) {
        if (values.containsKey('CampusTrips') &&
            values['CampusTrips'] is Map<dynamic, dynamic>) {
          (values['CampusTrips'] as Map<dynamic, dynamic>)
              .forEach((key, value) {
            // if (value is Map<String, dynamic>) {
            print('key is $key');
            print('value is $value');
            campusTripsDb.add(Trip.fromJson(value));
            // } else {
            // print("Invalid data structure for CampusTrips: $value");
            // }
          });
        }

        if (values.containsKey('HomeTrips') &&
            values['HomeTrips'] is Map<dynamic, dynamic>) {
          (values['HomeTrips'] as Map<dynamic, dynamic>).forEach((key, value) {
            if (value is Map<String, dynamic>) {
              homeTripsDb.add(Trip.fromJson(value));
            } else {
              print("Invalid data structure for HomeTrips: $value");
            }
          });
        }
      }

      trips = [campusTripsDb, homeTripsDb];
      print('trips: $trips');
    } catch (error) {
      print("Error fetching trips: $error");
      // Handle the error as needed
    }

    return trips;
  }

  addUserToDb(Map<String, dynamic> data) async {
    await reference.child('Users/').set(data);
  }

  getCurrentUser() async {
    final event = await reference
        .child('Users/${Authentication.instance.currentUserId}')
        .once();
    Map<dynamic, dynamic> values =
        event.snapshot.value as Map<dynamic, dynamic>;
    currentUser = User.fromJson(values);
    print(currentUser);
  }

  getTripRequests(String userId) async {
    List<TripRequest> tripRequests = [];

    final event = await reference
        .child('TripRequests/$userId')
        .orderByChild('status')
        .equalTo('pending')
        .once();
    //check if event has data
    if (event.snapshot.value == null) {
      return tripRequests;
    }
    Map<dynamic, dynamic> values =
        event.snapshot.value as Map<dynamic, dynamic>;
    print(values);
    values.forEach((key, value) {
      tripRequests.add(TripRequest.fromJson(value));
    });
    print('testingggggg $tripRequests');
    print(tripRequests.length);
    return tripRequests;
  }
  // getUserId(email){
  //   Authentication.currentUserId = email.replaceAll("@eng.asu.edu.eg", "");
  // }

  getPreviousTrips(String userId) async {
    final event = await reference
        .child('TripRequests/$userId')
        .orderByChild('status')
        .equalTo('completed')
        .once();

    Map<dynamic, dynamic> values =
        event.snapshot.value as Map<dynamic, dynamic>;
    print(values);

    List<TripRequest> tripRequests = [];
    values.forEach((key, value) {
      tripRequests.add(TripRequest.fromJson(value));
    });
    return tripRequests;
  }

  void addTripToDb(key, route, destination, data) async {
  
    await reference
        .child("Routes")
        .child(route)
        .child(destination)
        .child(key)
        .set(data);
  }

  void addTripToDriver(
    String generatedKey,
    Map<String, dynamic> data,
  ) {
    reference
        .child("Users")
        .child(Authentication.instance.currentUserId)
        .child("driverTrips")
        .child(generatedKey)
        .set(data);
  }

  getDriverTripsFromDb() async {
    List<Trip> driverTrips = [];
    final event = await reference
        .child("Users")
        .child(Authentication.instance.currentUserId)
        .child("driverTrips")
        .once();
    Map<dynamic, dynamic> values =
        event.snapshot.value as Map<dynamic, dynamic>;
    print(values);
    values.values.forEach((value) {
      driverTrips.add(Trip.fromJson(value));
    });

    return driverTrips;
  }

  getDriverTripRequests() async {
    List<TripRequest> tripRequests = [];
    final driverId = Authentication.instance.currentUserId;
    final event = await reference
        .child('Users')
        .child(driverId)
        .child('TripRequests')
        .once();
    if (event.snapshot.value != null) {
      Map<dynamic, dynamic> values =
          event.snapshot.value as Map<dynamic, dynamic>;
      values.values.forEach((element) {
        tripRequests.add(TripRequest.fromJson(element));
      });
    }
    return tripRequests;
  }

  acceptTripRequest(String requestId, String userId, String tripId,
      String pickup, String destination) async {
    String tripType;
    String route;

    if (destination == 'Gate 4' || destination == 'Gate 3') {
      tripType = 'CampusTrips';
      route = pickup + 'Route';
      route.replaceAll(' ', '');
    } else {
      tripType = 'HomeTrips';
      route = destination + 'Route';
      route.replaceAll(' ', '');
    }
    print('tripType: $tripType');
    print('route: $route');
    final trip = Trip.fromJson(await reference
        .child('Routes')
        .child(route)
        .child(tripType)
        .child(tripId)
        .get());
    if (trip.numberOfSeatsLeft > 0) {
      await reference
          .child('Users')
          .child(Authentication.instance.currentUserId)
          .child('TripRequests')
          .child(requestId)
          .child('status')
          .set('accepted');
      await reference
          .child('TripRequests')
          .child(userId)
          .child(requestId)
          .child('status')
          .set('accepted');
      await reference
          .child('Routes')
          .child(route)
          .child(tripType)
          .child(tripId)
          .child('numberOfSeatsLeft')
          .set(ServerValue.increment(-1));
    } else {
      return 'No seats available';
    }
  }

  void declineTripRequest(String requestId, String userId) async {
    await reference
        .child('Users')
        .child(Authentication.instance.currentUserId)
        .child('TripRequests')
        .child(requestId)
        .set(null);
    await reference
        .child('TripRequests')
        .child(userId)
        .child(requestId)
        .child('status')
        .set('declined');
  }

  void deleteRequest(String requestId, String user) async {
    await reference
        .child('Users')
        .child(Authentication.instance.currentUserId)
        .child('TripRequests')
        .child(requestId)
        .set(null);
  }

  
}
