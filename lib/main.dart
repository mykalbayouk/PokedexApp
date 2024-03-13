import 'package:flutter/material.dart';
import 'package:pokedex/pokemon_main.dart';
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
      ],
      builder: (context, child) { 
        return MaterialApp(
          title: 'Pokedex App',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          ),
          home: const PokemonMain(),
        );
      },
    );
  }
}
