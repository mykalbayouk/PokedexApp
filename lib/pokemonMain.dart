import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokedex/PokeObjects/pokemon.dart';
import 'package:pokedex/api.dart';
import 'package:pokedex/string_extension.dart';

Future<Pokemon> fetchPokemon(int id) async {
  final response = await getData('pokemon', id.toString());
  return Pokemon.fromJson(jsonDecode(response));
}

FutureBuilder<Pokemon> setupPokemon(int id) {
  return FutureBuilder<Pokemon>(
    future: fetchPokemon(id),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: const Text('Pokedex App'),
          ),
          body: Scaffold(
            backgroundColor: Theme.of(context).primaryColorLight,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DexType(id),
                    SizedBox(width: 20),
                    Text('#' + snapshot.data!.id.toString()),
                  ],
                ),
                PokeImage(snapshot.data!.image),
                Card(
                  color: Theme.of(context).secondaryHeaderColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      snapshot.data!.name.capitalize(),
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 200),
                PokeList(),
              ],
            ),
          ),
        );
      } else if (snapshot.hasError) {
        return Text('${snapshot.error}');
      }
      return const CircularProgressIndicator();
    },
  );
}

class PokemonMain extends StatefulWidget {
  const PokemonMain({super.key});

  @override
  State<PokemonMain> createState() => _PokemonMainState();
}

class _PokemonMainState extends State<PokemonMain> {
  @override
  Widget build(BuildContext context) {
    return setupPokemon(501);
  }
}

class PokeImage extends StatelessWidget {
  final Image image;
  const PokeImage(this.image, {super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width / 1.5,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: <Widget>[
              Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: image,
                ),
              ),
              Center(
                child: Image(
                  image: AssetImage('assets/images/pokedexFrame.png'),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DexType extends StatelessWidget {
  final int id;
  const DexType(this.id, {super.key});

  String getDexType(int id) {
    if (id < 152) {
      return 'Kanto';
    } else if (id < 252) {
      return 'Johto';
    } else if (id < 387) {
      return 'Hoenn';
    } else if (id < 494) {
      return 'Sinnoh';
    } else if (id < 650) {
      return 'Unova';
    } else if (id < 722) {
      return 'Kalos';
    } else if (id < 810) {
      return 'Alola';
    } else {
      return 'Galar';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text('PokeDex: ' + getDexType(id));
  }
}

class PokeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('poop');
  }
}
