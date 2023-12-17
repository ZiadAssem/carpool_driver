class Trip {
  // Route route;
  String tripKey;
  String gate;
  int price;
  String driverId;
  int numberOfSeatsLeft;
  String status;
  String date;
  String route;
  String destination;

  Trip({
    required this.tripKey,
    required this.gate,
    required this.driverId,
    required this.numberOfSeatsLeft,
    required this.price,
    required this.status,
    required this.date,
    required this.route,
    required this.destination,
    
  });

  factory Trip.fromJson(json) {
    return Trip(
        // route: Route.fromJson(json['route']),
        tripKey: json['tripKey'],
        gate: json['gate'],
        driverId: json['driverId'],
        numberOfSeatsLeft: json['numberOfSeatsLeft'],
        price: json['price'],
        status: json['status'],
        date: json['date'],
        route: json['route'],
        destination: json['destination']);
  }

  Map<String, dynamic> toJson() {
    return {
      // 'route': route,
      'tripKey': tripKey,
      'gate': gate,
      'driverId': driverId,
      'numberOfSeatsLeft': numberOfSeatsLeft,
      'price': price,
      'status': status,
      'date': date,
      'route': route,
      'destination': destination

      // Convert date to ISO 8601 string
    };
  }
}

// class HomeTrip extends Trip {
//   HomeTrip({
//   //  required route,
//     required tripKey,
//     required gate,
//     required driverId,
//     required numberOfSeatsLeft,
//     required price,
//     required status,
//     required date,
//   }) : super(

//         //  route: route,
//         tripKey: tripKey,
//           gate: gate,
//           driverId: driverId,
//           numberOfSeatsLeft: numberOfSeatsLeft,
//           price: price,
//           status: status,
//           date: date,
//         );
// }

// class CampusTrip extends Trip {
//   CampusTrip({
//  //   required route,
//  required tripKey,
//     required gate,
//     required driverId,
//     required numberOfSeatsLeft,
//     required price,
//     required status,
//     required date,
//   }) : super(
//     //      route: route,
//           tripKey: tripKey,
//           gate: gate,
//           driverId: driverId,
//           numberOfSeatsLeft: numberOfSeatsLeft,
//           price: price,
//           status: status,
//           date: date,
//         );
// }



// // class TripRequest {
// //   Trip trip;
// //   String rider;
// //   String status;

// //   TripRequest({
// //     required this.trip,
// //     required this.rider,
// //     required this.status,
// //   });

// //   factory TripRequest.fromJson(Map<String, dynamic> json) {
// //     return TripRequest(
// //       trip: Trip.fromJson(json['trip']),
// //       rider: json['rider'],
// //       status: json['status'],
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'trip': trip,
// //       'rider': rider,
// //       'status': status,
// //     };
// //   }
// // }

