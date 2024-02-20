import 'package:flutter/material.dart';
import 'package:pokedex/pull_pokedex_api.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<DropdownMenuEntry<String>> dropdownMenuEntries = [
    const DropdownMenuEntry(
      value: 'pokemon',
      label: 'Pokemon',
    ),
    const DropdownMenuEntry(
      value: 'item',
      label: 'Item',
    ),
    const DropdownMenuEntry(
      value: 'location', 
      label: 'Location',
    ),
    const DropdownMenuEntry(
      value: 'region',
      label: 'region',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokedex App'),
      ),
      body: Column(
        children: [
          DropdownMenu(
            dropdownMenuEntries: dropdownMenuEntries
                .map((DropdownMenuEntry<String> e) => e)
                .toList(),
            onSelected: (String? value) {
                context.read<PokemonState>().setType(value!);
            },
            ),
          TextField(
            onSubmitted: (String value) {
              setState(() {
                context.read<PokemonState>().setPokemonName(value);
              });
            },
          ),
          Center(
            child: FutureBuilder<Item>(
              future: fetchItem(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Text(snapshot.data!.name.toUpperCase()),
                      Text("ID: ${snapshot.data!.id}"),
                      Text("Height: ${snapshot.data!.category}"),
                      Text("Weight: ${snapshot.data!.cost}"),
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