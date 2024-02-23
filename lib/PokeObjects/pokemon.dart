import 'package:flutter/material.dart';
import 'package:pokedex/api.dart';

class Pokemon {
  final String name;
  final int id;
  final int height;
  final int weight;
  final Image image;
  final List types;

  Pokemon({
    required this.name,
    required this.id,
    required this.height,
    required this.weight,
    required this.image,
    required this.types,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      id: json['id'],
      height: json['height'],
      weight: json['weight'],
      image: Image.network(json['sprites']['front_default']),
      types: json['types'],
    );
  }
}

// location of this code is TBD

// Future<Pokemon> fetchPokemon(int id) async {
//   final response = await getData('pokemon', id.toString());
//   if (response.statusCode == 200) {
//     return Pokemon.fromJson(response.body);
//   } else {
//     throw Exception('Failed to load Pokemon');
//   }
// }