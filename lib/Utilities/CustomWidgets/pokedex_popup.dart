import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokedex/Utilities/CustomWidgets/custom_progress.dart';
import 'package:pokedex/Utilities/Functions/api.dart';
import 'package:pokedex/Utilities/Functions/string_extension.dart';
import 'package:pokedex/pokeobjects/pokedex.dart';

Future<Pokedex> fetchPokedex(String url) async {
  final response = await getData('pokedex', url);
  return Pokedex.fromJson(jsonDecode(response));
}

void pokedexPopUp(BuildContext context, String name) {    
  String getDexName(String name){
    switch(name){
      case 'Kanto':
        return 'kanto';
      case 'Johto':
        return 'original-johto';
      case 'Hoenn':
        return 'hoenn';
      case 'Sinnoh':
        return 'original-sinnoh';
      case 'Unova':
        return 'original-unova';
      case 'Kalos':
        return 'kalos-central';
      case 'Alola':
        return 'original-alola';
      case 'Galar':
        return 'galar';
      case 'Hisui':
        return 'hisui';
      case 'Paldea':
        return 'paldea';
      default:
        return name.toLowerCase();      
    }
  }

  String getDexRange(String name){
    switch(name){
      case 'Kanto':
        return '1-151';
      case 'Johto':
        return '152-251';
      case 'Hoenn':
        return '252-386';
      case 'Sinnoh':
        return '387-493';
      case 'Unova':
        return '494-649';
      case 'Kalos':
        return '650-721';
      case 'Alola':
        return '722-809';
      case 'Galar':
        return '810-898';
      case 'Hisui':
        return '899-904';
      case 'Paldea':
        return '905-';
      default:
        return name.toLowerCase();      
    }
  
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        title: Text(makePretty(name),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            )
        ),
        content: FutureBuilder<Pokedex>(
          future: fetchPokedex(getDexName(name)),
          builder: (context, snapshot) {
            if (snapshot.hasData) {                
              return Text(
                '${snapshot.data!.description}\n\nRange: ${getDexRange(name)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).primaryColor,
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return customProgressIndicator(context, Theme.of(context).secondaryHeaderColor);   
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}