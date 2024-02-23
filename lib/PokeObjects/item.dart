import 'package:flutter/material.dart';

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