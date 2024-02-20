import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String name_global = '501';
class PokemonState extends ChangeNotifier {


  void setPokemonName(String name) {
    name_global = name;
    notifyListeners();
  }


}

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

Future getData() async {


  Uri url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$name_global/');
  http.Response response = await http.get(url);
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to load posts');
  }
}


  Future<Pokemon> fetchPokemon() async {
    final response = await getData();
    final pokemon = Pokemon.fromJson(jsonDecode(response));
    return pokemon;
  }