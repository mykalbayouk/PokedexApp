import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokedex/PokeObjects/pokemon.dart';
import 'package:pokedex/Utilities/read_txt_file.dart';
import 'package:pokedex/Utilities/api.dart';
import 'package:pokedex/Utilities/string_extension.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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
                  SizedBox(width: 110),
                  Text(
                    'No. ' + snapshot.data!.id.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
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
              SizedBox(height: 50),
              PokeList(snapshot.data!.id, pokeList),
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
              return pokeList.where((String option) {
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
                    child: Image(
                      image: image.image,
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.5,
                    )),
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

class PokeList extends StatefulWidget {
  final int id;
  final List<String> pokeList;
  const PokeList(this.id, this.pokeList, {super.key});

  @override
  State<PokeList> createState() => _PokeListState();
}

class _PokeListState extends State<PokeList> {
  ItemScrollController scrollController = ItemScrollController();
  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  @override
  Widget build(BuildContext context) {
    var appstate = context.read<PokeAppState>();
    bool updated = appstate.updated;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (updated) {
        setState(() {
          appstate.setUpdated(false);
        });
        print("Appstate: ${appstate.id - 1}");
        print("Index: ${widget.id - 1}");
        scrollController.jumpTo(index: widget.id - 1);
      }
    });

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
          itemCount: widget.pokeList.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: widget.pokeList[index] == widget.pokeList[widget.id - 1]
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).secondaryHeaderColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.circle,
                  color:
                      widget.pokeList[index] == widget.pokeList[widget.id - 1]
                          ? Theme.of(context).primaryColorLight
                          : Theme.of(context).primaryColor,
                ),
                trailing: Text(
                  "No. " + (index + 1).toString(),
                  style: TextStyle(
                    color:
                        widget.pokeList[index] == widget.pokeList[widget.id - 1]
                            ? Theme.of(context).primaryColorLight
                            : Theme.of(context).primaryColor,
                  ),
                ),
                title: Text(
                  widget.pokeList[index],
                  style: TextStyle(
                    color:
                        widget.pokeList[index] == widget.pokeList[widget.id - 1]
                            ? Theme.of(context).primaryColorLight
                            : Theme.of(context).primaryColor,
                  ),
                ),
                onTap: () {
                  appstate.setName(widget.pokeList[index].toLowerCase());
                  scrollController.scrollTo(
                    index: index,
                    duration: Duration(seconds: 1),
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
