import 'package:flutter/material.dart';

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
      image: Image.network(json['sprites']['other']['official-artwork']['front_default']),
      types: json['types'],
    );
  }
}


