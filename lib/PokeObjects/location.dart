import 'package:pokedex/PokeObjects/region.dart';

class Location {
  final String name;
  final int id;
  final Region region;
  final List gameIndices;  

  Location({
    required this.name,
    required this.id,
    required this.region,
    required this.gameIndices,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      id: json['id'],
      region: json['region']['name'],
      gameIndices: json['game_indices'],
    );
  }
}