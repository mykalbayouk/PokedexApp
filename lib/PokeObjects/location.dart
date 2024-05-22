import 'package:pokedex/pokeobjects/versions.dart';

/// A class that represents the location where a Pokemon can be found.
/// Stores the name of the location and the versions where it can be found.
class Location {  
  // location its found
  final String name;
  final List<Versions> versions;

  Location({
    required this.name,
    required this.versions,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['location_area']['name'],
      versions: (json['version_details'] as List)
          .map((e) => Versions.fromJson(e))
          .toList(),
    );
  }
}