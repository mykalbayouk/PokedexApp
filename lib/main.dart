import 'package:flutter/material.dart';
import 'package:pokedex/layouts/pokemon_details.dart';
import 'package:pokedex/layouts/pokemon_main.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PokeAppState()),
        ChangeNotifierProvider(create: (context) => DetailAppState()),
      ],
      builder: (context, child) {
        return MaterialApp(
          title: 'Pokedex App',
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: const Color.fromARGB(255, 159, 0, 0),
            secondaryHeaderColor: const Color.fromARGB(255, 255, 255, 255),
            primaryColorLight: const Color.fromARGB(255, 212, 212, 212),
            cardColor: const Color.fromARGB(255, 199, 199, 199),
            primaryColorDark: const Color.fromARGB(255, 82, 0, 0),            
          ),
          home: const PokemonMain(),
        );
      },
    );
  }
}
