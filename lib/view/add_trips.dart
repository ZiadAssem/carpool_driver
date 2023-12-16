import 'package:carpool_driver/controller/addtrip_controller.dart';
import 'package:carpool_driver/reusable_widgets.dart';
import 'package:flutter/material.dart';

import '../classes_updated/routes_class.dart' as R;
import '../firebase/database.dart';

class AddTripsPage extends StatefulWidget {
  const AddTripsPage({super.key});

  @override
  State<AddTripsPage> createState() => _AddTripsPageState();
}

class _AddTripsPageState extends State<AddTripsPage> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _priceController = TextEditingController();
  final _seatsController = TextEditingController();
  String _selectedOption = 'toCampus';
  String _selectedGate = 'Gate 3';
  String? _selectedRoute;

  late Future<List<R.Route>> _routesFuture;

  @override
  void initState() {
    super.initState();
    _routesFuture = DatabaseHelper.instance.getRoutesFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: reusableAppBar('Add Trip'),
      body: _addTripForm(),
    );
  }

  Widget _addTripForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),
            Card(
              shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black, width: 0.7),
                  borderRadius: BorderRadius.circular(30.0)),
              elevation: 10,
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("Route"),
                  ),

                  _RoutesDropDown(
                    selectedRoute: _selectedRoute,
                    onRouteChanged: (newValue) {
                      setState(() {
                        _selectedRoute = newValue;
                      });
                    },
                    routesFuture: _routesFuture,
                  ),
                  // ),
                ],
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black, width: 0.7),
                  borderRadius: BorderRadius.circular(30.0)),
              elevation: 10,
              child: Row(
                children: [
                  Column(children: [
                    _customRadioButton(
                        value: 'toCampus',
                        groupValue: _selectedOption,
                        onChanged: (value) {
                          setState(() {
                            _selectedOption = value;
                          });
                        }),
                    _customRadioButton(
                        value: 'toHome',
                        groupValue: _selectedOption,
                        onChanged: (value) {
                          setState(() {
                            _selectedOption = value;
                          });
                        }),
                  ]),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                  ),
                  Column(
                    children: [
                      _customRadioButton(
                          value: 'Gate 3',
                          groupValue: _selectedGate,
                          onChanged: (value) {
                            setState(() {
                              _selectedGate = value;
                            });
                          }),
                      _customRadioButton(
                          value: 'Gate 4',
                          groupValue: _selectedGate,
                          onChanged: (value) {
                            setState(() {
                              _selectedGate = value;
                            });
                          }),
                    ],
                  )
                ],
              ),
            ),
            // reusableTextField(
            //     'Date', Icons.date_range, false, _dateController, null, false),
            _datePickerField(),
            reusableTextField(
              'Price',
              Icons.money,
              false,
              _priceController,
              null,
            ),
            reusableTextField(
              'Seats',
              Icons.event_seat,
              false,
              _seatsController,
              null,
            ),
            const SizedBox(
              height: 60,
            ),
            resuableButton(context, 'Add Trip', 200.0, () {_validateTripData();}),
          ],
        ),
      ),
    );
  }

  _validateTripData(){
    if(_formKey.currentState!.validate()){
       AddTripController.addTrip(context ,_selectedRoute, _selectedOption,_selectedGate, _dateController.text,int.parse( _priceController.text), int.parse(_seatsController.text));
      _formKey.currentState!.reset();
    
    }
  }

  Widget _datePickerField() {
    return GestureDetector(
      onTap: () {
        _selectDate(context);
      },
      child: Card(
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black, width: 0.7),
            borderRadius: BorderRadius.circular(30.0)),
        elevation: 10,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Date'),
                  Text(
                    _dateController.text,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime pickedDate = DateTime.now();
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: pickedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null && selectedDate != pickedDate) {
      setState(() {
        pickedDate = selectedDate;
        _dateController.text = pickedDate
            .toLocal()
            .toString()
            .split(' ')[0]; // Format the date as needed
        print(_dateController.text);
      });
    }
  }

  Widget _customRadioButton({
    required String value,
    required String groupValue,
    required Function(String) onChanged,
  }) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: groupValue,
          onChanged: (newValue) {
            onChanged(newValue as String);
          },
        ),
        Text(value == 'toCampus'
            ? 'To Campus'
            : value == 'Gate 3'
                ? 'Gate 3'
                : value == 'Gate 4'
                    ? 'Gate 4'
                    : 'To Home'),
      ],
    );
  }

}

class _RoutesDropDown extends StatelessWidget {
  final String? selectedRoute;
  final Function(String?) onRouteChanged;
  final Future<List<R.Route>> routesFuture;

  const _RoutesDropDown({
    Key? key,
    required this.selectedRoute,
    required this.onRouteChanged,
    required this.routesFuture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: routesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<R.Route> routes = snapshot.data as List<R.Route>;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: selectedRoute,
                onChanged: onRouteChanged,
                items: routes.map((R.Route route) {
                  return DropdownMenuItem<String>(
                    value: route.location,
                    child: Text(route.location!),
                  );
                }).toList(),
                hint: Text('Select a location'),
              ),
              SizedBox(height: 20),
            ],
          );
        }
      },
    );
  }
}
