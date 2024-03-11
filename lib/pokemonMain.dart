import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pokedex/PokeObjects/pokemon.dart';
import 'package:pokedex/api.dart';
import 'package:pokedex/Utilities/string_extension.dart';
import 'package:provider/provider.dart';


class PokeAppState extends ChangeNotifier {
  int id = 1;
  void increment() {
    id++;
    notifyListeners();
  }
  void decrement() {
    id--;
    notifyListeners();
  }

  void setId(int newId) {
    if (newId > 0 && newId <= 1025) {
      id = newId;
    } else {
      id = 1;
    }
    notifyListeners();
  }
}

Future<Pokemon> fetchPokemon(int id) async {
  final response = await getData('pokemon', id.toString());
  return Pokemon.fromJson(jsonDecode(response));
}

FutureBuilder<Pokemon> setupPokemon(int id) {
  return FutureBuilder<Pokemon>(
    future: fetchPokemon(id),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
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
                //PokeList(),
              ],
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

class _PokemonMainState extends State<PokemonMain> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
    void initState() {
      super.initState();
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
      );
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    var appstate = context.watch<PokeAppState>();
    int id = appstate.id;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
            child: IconButton(
              icon: Image.asset(
                'assets/images/Pokeball.png',
                height: MediaQuery.of(context).size.height / 20,
                width: MediaQuery.of(context).size.width,
              ),
              onPressed: () {
                _controller.forward(from: 0.0);
              },
              ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Pokemon ID',
              ),
              onSubmitted: (String value) {
                appstate.setId(int.parse(value));
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (id > 1) {
                        appstate.decrement();
                      } else {
                        appstate.setId(1025);
                      }
                    });
                  },
                  child: const Text('<'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (id < 1025) {
                       appstate.increment();
                      } else {
                        appstate.setId(1);
                      }
                    });
                  },
                  child: const Text('>'),
                ),
              ],
            ),
            setupPokemon(id),
          ],
        ),
      ),
    );
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
