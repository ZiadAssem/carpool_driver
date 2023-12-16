import 'package:carpool_driver/classes_updated/trip_class.dart';
import 'package:carpool_driver/firebase/database.dart';
import 'package:carpool_driver/reusable_widgets.dart';
import 'package:flutter/material.dart';

class ViewTrips extends StatefulWidget {
  const ViewTrips({super.key});

  @override
  State<ViewTrips> createState() => _ViewTripsPageState();
}

class _ViewTripsPageState extends State<ViewTrips> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: reusableAppBar('View Trips'),
      body: _viewTripsList(),
    );
  }

  Widget _viewTripsList() {
    return FutureBuilder(
        future: DatabaseHelper.instance.getDriverTripsFromDb(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error'));
          } else if (snapshot.hasData) {
            final trips = snapshot.data as List<Trip>;
            _sortTrips(trips);

            return ListView.builder(
              itemCount: trips.length,
              itemBuilder: (context, index) {
                return _buildTrip(trips, index);
              },
            );
          } else {
            return Center(child: Text('No Trips Found'));
          }
        });
  }

  Widget _buildTrip(trips, index) {
    return Card(
      elevation: 10,
      child: ListTile(
        title: Text('Route: ' + trips[index].route),
        subtitle: Text(
            'Heading to: ' + trips[index].destination.replaceAll('to', '')),
        trailing: Column(
          children: [
            Text(trips[index].date),
            Text(trips[index].gate),
            Text(trips[index].status.toString(),
        

            ),
            
            
          ],
        ),
        leading:
            Text('Seats Left: ' + trips[index].numberOfSeatsLeft.toString()),
      ),
    );
  }

  _sortTrips(List<Trip> trips) {
    // Sort the list based on the "status" attribute
    trips.sort((a, b) {
      String statusA = a.status;
      String statusB = b.status;

      // "awaiting" comes before other statuses
      if (statusA == "awaiting" && statusB != "awaiting") {
        return -1;
      } else if (statusA != "awaiting" && statusB == "awaiting") {
        return 1;
      } else {
        // For other statuses, maintain the original order
        return 0;
      }
    });

    // Convert the sorted list back to a map
  }
}
