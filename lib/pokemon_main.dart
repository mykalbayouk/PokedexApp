import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokedex/PokeObjects/pokemon.dart';
import 'package:pokedex/Utilities/pokeimage.dart';
import 'package:pokedex/Utilities/read_txt_file.dart';
import 'package:pokedex/Utilities/api.dart';
import 'package:pokedex/Utilities/string_extension.dart';
import 'package:pokedex/pokemon_details.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class PokeAppState extends ChangeNotifier {
  int id = 1;
  String name = "bulbasaur";
  bool isName = false;
  bool updated = false;

  void setId(int newId) {
    id = newId;
    notifyListeners();
  }

  void setName(String newName) {
    name = newName;
    isName = true;
    notifyListeners();
  }

  void setUpdated(bool newUpdated) {
    updated = newUpdated;
    notifyListeners();
  }
}

Future<Pokemon> fetchPokemon(int id) async {
  final response = await getData('pokemon', id.toString());
  return Pokemon.fromJson(jsonDecode(response));
}

Future<Pokemon> fetchPokemonName(String name) async {
  final response = await getData('pokemon', name);
  return Pokemon.fromJson(jsonDecode(response));
}

FutureBuilder<Pokemon> setupPokemon(
    int id, String name, bool isName, List<String> pokeList) {
  return FutureBuilder<Pokemon>(
    future: isName ? fetchPokemonName(name) : fetchPokemon(id),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        if (isName) {
          context.watch<PokeAppState>().id = snapshot.data!.id;
        }
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
                  DexType(snapshot.data!.id),
                  const SizedBox(width: 110),
                  Text(
                    'No. ${snapshot.data!.id}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              PokeImage(snapshot.data!.image, 1),
              ElevatedButton(
                onPressed: () {                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PokeDetails(snapshot: snapshot)),
                  );
                },
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
              const SizedBox(height: 50),
              PokeList(pokeList),
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

class _PokemonMainState extends State<PokemonMain>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  List<String> pokeList = [];

  void pokelist() async {
    String data = await loadAsset('assets/raw/poke_list.txt');
    setState(() {
      pokeList = data.split('\n');
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    pokelist();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void showPokemonPopUp(BuildContext context) {
    var appstate = context.read<PokeAppState>();
    var myValue;
    bool isName = false;

    List<String> pokeListMine = [];
    for (int i = 0; i < pokeList.length; i++) {
      pokeListMine.add(pokeList[i].split(',')[0]);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'Enter a Pokemon ID or Name',
            style: TextStyle(
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          content: Autocomplete<String>(
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 4.0,
                  color: Theme.of(context).secondaryHeaderColor,
                  child: SizedBox(
                    height: options.length * 70.0,
                    width: MediaQuery.of(context).size.width * .68,
                    child: ListView.separated(
                      padding: EdgeInsets.all(5),
                      shrinkWrap: false,
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            options.elementAt(index),
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          onTap: () {
                            onSelected(options.elementAt(index));
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          indent: 10,
                          endIndent: 10,
                          color: Theme.of(context).primaryColor,
                        );
                      },
                    ),
                  ),
                ),
              );
            },
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<String>.empty();
              } else if (int.tryParse(textEditingValue.text) != null) {
                if (int.parse(textEditingValue.text) > 1025 ||
                    int.parse(textEditingValue.text) < 1) {
                  return const Iterable<String>.empty();
                } else {
                  return Iterable.generate(1, (index) => textEditingValue.text);
                }
              }
              return pokeListMine.where((String option) {
                return option.contains(textEditingValue.text.capitalize());
              });
            },
            onSelected: (var selection) {
              if (selection is int) {
                isName = false;
              } else {
                isName = true;
              }
              myValue = selection;
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (isName) {
                  appstate.setName(myValue.toLowerCase());
                } else {
                  appstate.setId(int.parse(myValue));
                }
                appstate.setUpdated(true);
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var appstate = context.watch<PokeAppState>();
    int id = appstate.id;
    String name = appstate.name;
    bool isName = appstate.isName;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3.0),
          child: RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
            child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Image.asset(
                'assets/images/Pokeball.png',
                height: MediaQuery.of(context).size.height / 20,
                width: MediaQuery.of(context).size.width,
              ),
              onPressed: () {
                _controller.forward(from: 0.0);
                showPokemonPopUp(context);
              },
            ),
          ),
        ),
      ),
      body: setupPokemon(id, name, isName, pokeList),
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
    } else if (id < 898) {
      return 'Galar';
    } else if (id < 905) {
      return 'Hisui';
    } else {
      return 'Paldea';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          getDexType(id),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColorLight,
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class PokeList extends StatelessWidget {
  static int test = 0;
  final List<String> pokeListFull;

  PokeList(this.pokeListFull, {super.key});

  List<String> types = [];

  List<String> parsePL() {
    List<String> pokeList = [];
    for (int i = 0; i < pokeListFull.length; i++) {
      pokeList.add(pokeListFull[i].split(',')[0]);
      types.add(pokeListFull[i].split(',')[1]);
      types.add(pokeListFull[i].split(',')[2]);
      types.add('-');
    }
    return pokeList;
  }

  @override
  Widget build(BuildContext context) {
    test++;
    ItemScrollController scrollController = ItemScrollController();
    ItemPositionsListener itemPositionsListener =
        ItemPositionsListener.create();
    var appstate = context.read<PokeAppState>();
    int id = appstate.id;

    List<String> pokeList = parsePL();

    // worlds most jank solution to a problem
    if (test % 2 != 0 && appstate.updated == true) {
      Future.delayed(Duration.zero, () {
        scrollController.scrollTo(
          index: id - 1,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
        appstate.setUpdated(false);
      });
    }

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
        return Colors.pink;
      } else if (type == 'Fighting') {
        return Colors.red;
      } else if (type == 'Psychic') {
        return Colors.purple;
      } else if (type == 'Rock') {
        return Colors.brown;
      } else if (type == 'Steel') {
        return Colors.grey;
      } else if (type == 'Ice') {
        return Colors.blue;
      } else if (type == 'Ghost') {
        return Colors.purple;
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

    SizedBox typeIcon(String type, bool selected) {
      if (type == '') {
        return SizedBox();
      }

      return SizedBox(
        child: ImageIcon(
          Svg('assets/images/type_short_icons/$type.svg'),
          size: 25,
          color: !selected
              ? chooseColor(type)
              : Theme.of(context).primaryColorLight,
        ),
      );
    }

    return Card(
      color: Theme.of(context).secondaryHeaderColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width / 1.25,
        height: MediaQuery.of(context).size.height / 4,
        child: ScrollablePositionedList.builder(
          itemScrollController: scrollController,
          itemPositionsListener: itemPositionsListener,
          itemCount: pokeList.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: pokeList[index] == pokeList[id - 1]
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).secondaryHeaderColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    typeIcon(
                        types[index * 3], pokeList[index] == pokeList[id - 1]),
                    typeIcon(types[index * 3 + 1],
                        pokeList[index] == pokeList[id - 1]),
                  ],
                ),
                trailing: Text(
                  "No. ${index + 1}",
                  style: TextStyle(
                    color: pokeList[index] == pokeList[id - 1]
                        ? Theme.of(context).primaryColorLight
                        : Theme.of(context).primaryColor,
                  ),
                ),
                title: Text(
                  pokeList[index],
                  style: TextStyle(
                    color: pokeList[index] == pokeList[id - 1]
                        ? Theme.of(context).primaryColorLight
                        : Theme.of(context).primaryColor,
                  ),
                ),
                onTap: () {
                  appstate.setName(pokeList[index].toLowerCase());
                  scrollController.scrollTo(
                    index: index,
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
