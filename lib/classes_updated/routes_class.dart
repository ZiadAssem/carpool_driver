class Route {
  String? location;

  Route({required this.location});

  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      location: json['location'],
    );
  }

  toJson() {
    return {
      'location': location,
    };
  }
}

Route maadiRoute = Route(location: 'Maadi');
Route newCairoRoute = Route(location: 'New Cairo');
Route helioplisRoute = Route(location: 'Helioplis');
Route downtownRoute = Route(location: 'Downtown');
Route octoberRoute = Route(location: '6th of October');
Route zamalekRoute = Route(location: 'Zamalek');
Route haramRoute = Route(location: 'Haram');
Route nasrCityRoute = Route(location: 'Nasr City');

List<Route> routesLocations = [
  maadiRoute,
  newCairoRoute,
  helioplisRoute,
  downtownRoute,
  octoberRoute,
  zamalekRoute,
  haramRoute,
  nasrCityRoute,
];
