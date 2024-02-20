import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String _describer = '501';
String _type = 'pokemon';
class PokemonState extends ChangeNotifier {


  void setPokemonName(String pokemonName) {
    _describer = pokemonName;
    notifyListeners();
  }

  void setType(String type) {
    _type = type;
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

class Item {
  final String name;
  final int id;
  final int cost;
  final String category;
  final String effect;
  final Image image;

  Item({
    required this.name,
    required this.id,
    required this.cost,
    required this.category,
    required this.effect,
    required this.image,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'],
      id: json['id'],
      cost: json['cost'],
      category: json['category']['name'],
      effect: json['effect_entries'][0]['effect'],
      image: Image.network(json['sprites']['default']),
    );
  }

}

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

class Region {
  final String name;
  final int id;
  final List locations;

  Region({
    required this.name,
    required this.id,
    required this.locations,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      name: json['name'],
      id: json['id'],
      locations: json['locations'],
    );
  }

}

class Machines {
  final int id;
  final String name;
  final String item;
  final String move;

  Machines({
    required this.id,
    required this.name,
    required this.item,
    required this.move,
  });

  factory Machines.fromJson(Map<String, dynamic> json) {
    return Machines(
      id: json['id'],
      name: json['name'],
      item: json['item'],
      move: json['move'],
    );
  }
}

class Moves {
  final String name;
  final int id;
  final int accuracy;
  final int power;
  final int pp;
  final String type;
  final String damageClass;
  final String effect;

  Moves({
    required this.name,
    required this.id,
    required this.accuracy,
    required this.power,
    required this.pp,
    required this.type,
    required this.damageClass,
    required this.effect,
  });

  factory Moves.fromJson(Map<String, dynamic> json) {
    return Moves(
      name: json['name'],
      id: json['id'],
      accuracy: json['accuracy'],
      power: json['power'],
      pp: json['pp'],
      type: json['type']['name'],
      damageClass: json['damage_class']['name'],
      effect: json['effect_entries'][0]['effect'],
    );
  }
}

class Types {
  final String name;
  final int id;
  final List doubleDamageFrom;
  final List doubleDamageTo;
  final List halfDamageFrom;
  final List halfDamageTo;
  final List noDamageFrom;
  final List noDamageTo;
  final List pokemon;
  final List moves;

  Types({
    required this.name,
    required this.id,
    required this.doubleDamageFrom,
    required this.doubleDamageTo,
    required this.halfDamageFrom,
    required this.halfDamageTo,
    required this.noDamageFrom,
    required this.noDamageTo,
    required this.pokemon,
    required this.moves,
  });

  factory Types.fromJson(Map<String, dynamic> json) {
    return Types(
      name: json['name'],
      id: json['id'],
      doubleDamageFrom: json['damage_relations']['double_damage_from'],
      doubleDamageTo: json['damage_relations']['double_damage_to'],
      halfDamageFrom: json['damage_relations']['half_damage_from'],
      halfDamageTo: json['damage_relations']['half_damage_to'],
      noDamageFrom: json['damage_relations']['no_damage_from'],
      noDamageTo: json['damage_relations']['no_damage_to'],
      pokemon: json['pokemon'],
      moves: json['moves'],
    );
  }

}


Future getData() async {
  Uri url = Uri.parse('https://pokeapi.co/api/v2/$_type/$_describer/');
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

Future<Item> fetchItem() async {
  final response = await getData();
  final item = Item.fromJson(jsonDecode(response));
  return item;
}

