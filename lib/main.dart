import 'package:flutter/material.dart';
import 'package:pokedex/layout.dart';
import 'package:pokedex/api.dart';
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
        ChangeNotifierProvider(create: (context) => APIState()),
      ],
      builder: (context, child) { 
        return MaterialApp(
          title: 'Pokedex App',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.red.shade100),
          ),
          home: const MyHomePage(),
        );
      },
    );
  }
}
