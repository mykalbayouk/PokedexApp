import 'package:flutter/material.dart';
import 'package:pokedex/layouts/pokemon_main.dart';

class Pokemon {
  final String name;
  final int id;
  final int height;
  final int weight;
  final Image image;
  final Image sprite;
  final Image shinySprite;
  final List types;
  final List abilities;
  final List moves;

  Pokemon({
    required this.name,
    required this.id,
    required this.height,
    required this.weight,
    required this.image,
    required this.sprite,
    required this.shinySprite,
    required this.types,
    required this.abilities,
    required this.moves,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      id: json['id'],
      height: json['height'],
      weight: json['weight'],
      image: Image.network(json['sprites']['other']['official-artwork']['front_default']),
      sprite: Image.network(json['sprites']['front_default']),
      shinySprite: Image.network(json['sprites']['front_shiny']),
      types: json['types'],
      abilities: json['abilities'],      
      moves: json['moves'],
    );
  }
}


