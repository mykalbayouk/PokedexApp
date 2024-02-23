import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class APIState extends ChangeNotifier {

}

Future getData(String type, String describer) async {
  Uri url = Uri.parse('https://pokeapi.co/api/v2/$type/$describer/');
  http.Response response = await http.get(url);
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to load posts');
  }
}



