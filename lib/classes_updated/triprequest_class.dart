class TripRequest{
  String tripId;
  String user;
  String driver;
  String status;
  String pickup;
  String destination;

  TripRequest({
    required this.tripId,
    required this.driver,
    required this.user,
    required this.status,
    required this.pickup,
    required this.destination,
  });

  Map<String, dynamic> toJson() {
    return {
      'tripId': tripId,
      'driver': driver,
      'user': user,
      'status': status,
      'pickup': pickup,
      'destination': destination,
    };
  }

  static TripRequest fromJson(value) {
    return TripRequest(
      tripId: value['tripId'],
      driver: value['driver'],
      user: value['user'],
      status: value['status'],
      pickup: value['pickup'],
      destination: value['destination'],
    );
  }
}