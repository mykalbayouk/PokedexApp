import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokedex/PokeObjects/pokemon.dart';
import 'package:pokedex/Utilities/CustomWidgets/custom_progress.dart';
import 'package:pokedex/Utilities/Functions/dex_type.dart';
import 'package:pokedex/Utilities/CustomWidgets/pokeimage.dart';
import 'package:pokedex/Utilities/Functions/read_txt_file.dart';
import 'package:pokedex/Utilities/Functions/api.dart';
import 'package:pokedex/Utilities/Functions/string_extension.dart';
import 'package:pokedex/Utilities/Functions/type_color.dart';
import 'package:pokedex/layouts/pokemon_details.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

/// State management class for the PokemonMain widget
class PokeAppState extends ChangeNotifier {
  int id = 1;
  String name = "bulbasaur";
  bool isName = false;
  bool updated = false;

  /// sets the ID of the Pokemon
  void setId(int newId) {
    id = newId;
    notifyListeners();
  }

  /// sets the name of the Pokemon
  void setName(String newName) {
    name = newName;
    isName = true;
    notifyListeners();
  }
/// sets the updated status of the Pokemon
  void setUpdated(bool newUpdated) {
    updated = newUpdated;
    notifyListeners();
  }
}
/// Fetches the Pokemon data from the API using the ID
Future<Pokemon> fetchPokemon(int id) async {
  final response = await getData('pokemon', id.toString());
  return Pokemon.fromJson(jsonDecode(response));
}

/// Fetches the Pokemon data from the API using the name
Future<Pokemon> fetchPokemonName(String name) async {
  final response = await getData('pokemon', name);
  return Pokemon.fromJson(jsonDecode(response));
}

/// Sets up the Pokemon Main Screen 
FutureBuilder<Pokemon> setupPokemon(
    int id, String name, bool isName, List<String> pokeList) {
  return FutureBuilder<Pokemon>(
    future: isName ? fetchPokemonName(name) : fetchPokemon(id),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        // if the user searched by name, set the ID to the ID of the Pokemon
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
              // Display the Pokemon image
              PokeImage(snapshot.data!.image, 1),
              // Button clicks to go to the Pokemon Details page
              ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11.0),
                    ),
                  ),
                ),
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
              SizedBox(height: MediaQuery.of(context).size.height / 30),
              // Display the list of Pokemon
              PokeList(pokeList),
            ],
          ),
        );
      } else if (snapshot.hasError) {
        return Text('${snapshot.error}');
      }
      return customProgressIndicator(
          context, Theme.of(context).secondaryHeaderColor);
    },
  );
}

/// The main Pokemon screen showing the Pokemon image and list of Pokemon
class PokemonMain extends StatefulWidget {
  const PokemonMain({super.key});

  @override
  State<PokemonMain> createState() => _PokemonMainState();
}

class _PokemonMainState extends State<PokemonMain>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  List<String> pokeList = [];

  /// Loads the list of Pokemon from the text file
  void pokelist() async {
    String data = await loadAsset('assets/raw/poke_list.txt');
    setState(() {
      pokeList = data.split('\n');
    });
  }

  /// Initializes the animation controller
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

  /// Disposes the animation controller
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Shows the Pokemon search popup
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
          // creates autocomplete for the Pokemon search using the pokeList
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
                      padding: const EdgeInsets.all(5),
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
            // sets the value of the Pokemon search
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
                setState(() {
                  if (isName) {
                    appstate.setName(myValue.toLowerCase());
                  } else {
                    appstate.setId(int.parse(myValue));
                  }
                  appstate.setUpdated(true);
                  Navigator.of(context).pop();
                });
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
      bottomNavigationBar: BottomAppBar(
        height: MediaQuery.of(context).size.height / 20,
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[            
            IconButton(
              iconSize: 35,
              icon: const Icon(Icons.search),
              color: Theme.of(context).primaryColorLight,
              onPressed: () {
                showPokemonPopUp(context);
              },
            ),            
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).primaryColorLight,
      body: setupPokemon(id, name, isName, pokeList),
    );
  }
}

/// Displays the Pokedex the pokemon is found in
class DexType extends StatelessWidget {
  final int id;
  const DexType(this.id, {super.key});

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

/// Displays the list of Pokemon using the text file
// ignore: must_be_immutable
class PokeList extends StatelessWidget {
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

  /// Displays the list of Pokemon using a ScrollablePositionedList
  @override
  Widget build(BuildContext context) {
    ItemScrollController scrollController = ItemScrollController();
    ItemPositionsListener itemPositionsListener =
        ItemPositionsListener.create();
    var appstate = context.read<PokeAppState>();
    int id = appstate.id;

    List<String> pokeList = parsePL();    

    if (appstate.updated) {
      Future.delayed(Duration.zero, () {
        scrollController.scrollTo(
          index: id - 1,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );        
      });
    }

    SizedBox typeIcon(String type, bool selected) {
      if (type == '') {
        return const SizedBox();
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
        // displays list using ScrollablePositionedList
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
