import 'package:flutter/material.dart';
import 'package:pokedex/pull_pokedex_api.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokedex'),
      ),
      body: Column(
        children: [
          TextField(
            onSubmitted: (String value) {
              setState(() {
                context.read<PokemonState>().setPokemonName(value);
              });
            },
          ),
          Center(
            child: FutureBuilder<Pokemon>(
              future: fetchPokemon(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Text(snapshot.data!.name.toUpperCase()),
                      Text("ID: " + snapshot.data!.id.toString()),
                      Text("Height: " + snapshot.data!.height.toString()),
                      Text("Weight: " + snapshot.data!.weight.toString()),
                      Image(
                        image: snapshot.data!.image.image,
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}