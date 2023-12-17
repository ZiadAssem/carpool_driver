import 'package:carpool_driver/classes_updated/triprequest_class.dart';
import 'package:carpool_driver/reusable_widgets.dart';
import 'package:flutter/material.dart';

import '../firebase/database.dart';

class ViewTripRequests extends StatefulWidget {
  const ViewTripRequests({super.key});

  @override
  State<ViewTripRequests> createState() => _ViewTripRequestsState();
}

class _ViewTripRequestsState extends State<ViewTripRequests> {
  late final processTrips;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();

    final DateTime elevenThirtyPM =
        DateTime(now.year, now.month, now.day, 23, 30);
    final DateTime fourThirtyPM =
        DateTime(now.year, now.month, now.day, 16, 30);
    processTrips = DatabaseHelper.instance.getDriverTripRequests();
    for (var i = 0; i < processTrips.length; i++) {
      if (processTrips[i].status == 'awaiting') {
        if (processTrips[i].pickup == 'Gate 3' ||
            processTrips[i].pickup == 'Gate 4') {
          if (now.isAfter(fourThirtyPM)) {
            DatabaseHelper.instance.declineTripRequest(
              processTrips[i].requestId,
              processTrips[i].user,
            );
          }
        } else if (now.isAfter(elevenThirtyPM)) {
          DatabaseHelper.instance.declineTripRequest(
            processTrips[i].requestId,
            processTrips[i].user,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: reusableAppBar('View Trip Requests'),
      body: _viewTripRequestsList(),
    );
  }

  Widget _viewTripRequestsList() {
    return FutureBuilder(
        future: DatabaseHelper.instance.getDriverTripRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error'));
          } else if (snapshot.hasData) {
            final trips = snapshot.data as List<TripRequest>;

            return ListView.builder(
              itemCount: trips.length,
              itemBuilder: (context, index) {
                return _buildTripRequest(trips, index);
              },
            );
          } else {
            return const Center(child: Text('No Trips Found'));
          }
        });
  }

  //List tile to view trip request, with a button to confirm or decline
  Widget _buildTripRequest(List<TripRequest> trips, int index) {
    return Card(
      elevation: 10,
      child: ListTile(
        title: Text('User: ${trips[index].user}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Heading to: ${trips[index].destination.replaceAll('to', '')}'),
            const SizedBox(
                height: 8), // Add some spacing between the subtitle texts
            Text('Pickup: ${trips[index].pickup}'),
            Text(
              trips[index].status.toString(),
              style: TextStyle(
                color: trips[index].status == 'confirmed'
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ],
        ),
        trailing: trips[index].status == 'accepted'
            ? IconButton(
                onPressed: () {
                  DatabaseHelper.instance
                      .deleteRequest(trips[index].requestId, trips[index].user);
                },
                icon: const Icon(Icons.delete))
            : // If the trip is confirmed, don't show the buttons
            Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          if (DatabaseHelper.instance.acceptTripRequest(
                                trips[index].requestId,
                                trips[index].user,
                                trips[index].tripId,
                                trips[index].pickup,
                                trips[index].destination,
                              ) !=
                              null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("No seats left"),
                              ),
                            );
                          }
                          setState(() {});
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          DatabaseHelper.instance.declineTripRequest(
                            trips[index].requestId,
                            trips[index].user,
                          );
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
