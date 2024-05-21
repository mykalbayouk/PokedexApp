import 'package:flutter/material.dart';

Color chooseColor(String type) {
      if (type == 'Grass') {
        return Colors.green;
      } else if (type == 'Poison') {
        return Colors.purple;
      } else if (type == 'Fire') {
        return Colors.orange;
      } else if (type == 'Water') {
        return Colors.blue;
      } else if (type == 'Bug') {
        return Colors.green;
      } else if (type == 'Normal') {
        return Colors.grey;
      } else if (type == 'Electric') {
        return Colors.yellowAccent.shade700;
      } else if (type == 'Ground') {
        return Colors.brown;
      } else if (type == 'Fairy') {
        return const Color.fromARGB(255, 225, 116, 152);
      } else if (type == 'Fighting') {
        return Colors.red;
      } else if (type == 'Psychic') {
        return const Color.fromARGB(255, 238, 73, 169);
      } else if (type == 'Rock') {
        return Colors.brown;
      } else if (type == 'Steel') {
        return Colors.grey;
      } else if (type == 'Ice') {
        return Colors.blue;
      } else if (type == 'Ghost') {
        return const Color.fromARGB(255, 85, 32, 95);
      } else if (type == 'Dragon') {
        return Colors.blue;
      } else if (type == 'Flying') {
        return Colors.blue;
      } else if (type == 'Dark') {
        return Colors.black;
      } else {
        return Colors.grey;
      }
    }