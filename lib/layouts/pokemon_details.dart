// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex/PokeObjects/pokemon.dart';
import 'package:pokedex/Utilities/CustomWidgets/abilities_list.dart';
import 'package:pokedex/Utilities/CustomWidgets/custom_text.dart';
import 'package:pokedex/Utilities/CustomWidgets/type_matchups.dart';
import 'package:pokedex/Utilities/Functions/api.dart';
import 'package:pokedex/Utilities/Functions/dex_type.dart';
import 'package:pokedex/Utilities/CustomWidgets/pokeimage.dart';
import 'package:pokedex/Utilities/Functions/string_extension.dart';
import 'package:pokedex/pokeobjects/evo_details.dart';
import 'package:pokedex/pokeobjects/get_chain.dart';
import 'package:pokedex/pokeobjects/move.dart';
import 'package:pokedex/pokeobjects/species.dart';
import 'package:provider/provider.dart';

bool isPressed = false;

class DetailAppState extends ChangeNotifier {
  void changePressed() {
    isPressed = !isPressed;
    notifyListeners();
  }
}

Future<Species> fetchSpecies(String id) async {
  final response = await getData('pokemon-species', id);
  return Species.fromJson(jsonDecode(response));
}

Future<GetChain> fetchEvolutionChain(String id) async {
  final response = await getData('evolution-chain', id);
  return GetChain.fromJson(jsonDecode(response));
}

class PokeDetails extends StatefulWidget {
  AsyncSnapshot<Pokemon> snapshot;

  PokeDetails({super.key, required this.snapshot});

  @override
  State<PokeDetails> createState() => _PokeDetailsState();
}

class _PokeDetailsState extends State<PokeDetails> {
  @override
  void initState() {
    super.initState();
    isPressed = false;
  }

  void detailsPopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColorLight,
          title: CardText(
            "Details",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          content: speciesBuilder(widget.snapshot.data!.id.toString(),
              widget.snapshot.data!.height, widget.snapshot.data!.weight),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.read<DetailAppState>();
    var sprite = isPressed
        ? widget.snapshot.data!.shinySprite
        : widget.snapshot.data!.sprite;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.snapshot.data!.name.capitalize(),
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                          onTap: () => {
                                setState(() {
                                  appState.changePressed();
                                })
                              },
                          child: PokeImage(sprite, 2.5)),
                      IconButton(
                          icon: Icon(
                            Icons.more_horiz,
                            size: 30,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () => {detailsPopUp(context)}),
                    ],
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 3),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height / 20),
                      CardText(
                        'ID: ${widget.snapshot.data!.id}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: () => {
                          print("test"),
                        },
                        child: Text(
                          getDexType(widget.snapshot.data!.id),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      PokeType(widget.snapshot.data!.types),
                    ],
                  ),
                ],
              ),
              AbilitiesList(widget.snapshot.data!.abilities),
              EvolutionDisplay(id: widget.snapshot.data!.id.toString()),
              MovesDisplay(widget.snapshot.data!.moves),
            ],
          ),
        ),
      ),
    );
  }
}

FutureBuilder<Species> speciesBuilder(String id, int height, int weight) {
  return FutureBuilder<Species>(
    future: fetchSpecies(id),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "The ${snapshot.data!.genus}",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Height: $height',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 10),
                  Text(
                    'Weight: $weight',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 40),
              Text(
                makePretty(snapshot.data!.flavorTextEntries[
                    Random().nextInt(snapshot.data!.flavorTextEntries.length)]),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).primaryColor,
                ),
              ),
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

class PokeType extends StatelessWidget {
  final List types;
  const PokeType(this.types, {super.key});

  String fixy(String fix) {
    return fix.capitalize();
  }

  void typePopUp(BuildContext context, List types) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColorLight,
          title: Center(
            child: Text(
              "Type Matchups",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          content: TypeMatchups(types),
          actions: <Widget>[
            IconButton(
              onPressed: () => {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Theme.of(context).secondaryHeaderColor,
                      title: Center(
                        child: Text(
                          "Info",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      content: SizedBox(
                        height: MediaQuery.of(context).size.height / 18,
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: Text(
                          "Border means it is a quadruple type.\nSo either .25x or 4x damage depending on section.",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                ),
              },
              icon: Icon(
                Icons.info,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width / 2.5),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        typePopUp(context, types);
      },
      child: SizedBox(
        child: Column(
          children: [
            for (var type in types)
              SvgPicture.asset(
                  'assets/images/type_long_icons/${fixy(type['type']['name'])}.svg'),
          ],
        ),
      ),
    );
  }
}

class EvolutionDisplay extends StatelessWidget {
  final String id;
  const EvolutionDisplay({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Species>(
      future: fetchSpecies(id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return FutureBuilder<GetChain>(
            future: fetchEvolutionChain(snapshot.data!.evolutionChainID),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Card(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 8,
                    child: EvoImage(snapshot.data!.chain.allEvolutions,
                        snapshot.data!.chain.allDetails),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

class EvoImage extends StatelessWidget {
  final List<String> allEvolutions;
  final List<EvoDetails> evoDetails;
  const EvoImage(this.allEvolutions, this.evoDetails, {super.key});

  String evoDetailAttr(EvoDetails evoDetails) {
    if (evoDetails.trigger == 'level-up') {
      String level = evoDetails.minLevel.toString();
      if (level == '') {
        level = evoDetails.minHappiness.toString();
        return 'Happy: $level';
      } else {
        return 'Level: $level';
      }
    } else if (evoDetails.trigger == 'use-item') {
      return makePretty(evoDetails.item['name']);
    } else if (evoDetails.trigger == 'trade') {
      return 'Trade';
    } else {
      return evoDetails.trigger;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (allEvolutions.length == 1) {
      return FutureBuilder<List<Image>>(
        future: getImage(allEvolutions, 1.5),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              child: Image(
                image: snapshot.data![0].image,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      );
    } else if (allEvolutions.length == 2) {
      return FutureBuilder<List<Image>>(
        future: getImage(allEvolutions, 1),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => selectedMon(context, allEvolutions[0]),
                    child: Image(
                      image: snapshot.data![0].image,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          evoDetailAttr(evoDetails[0]),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Theme.of(context).primaryColor,
                        size: 50,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => selectedMon(context, allEvolutions[1]),
                    child: Image(
                      image: snapshot.data![1].image,
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      );
    } else if (allEvolutions.length == 3) {
      return FutureBuilder<List<Image>>(
        future: getImage(allEvolutions, .75),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => selectedMon(context, allEvolutions[0]),
                    child: Image(
                      image: snapshot.data![0].image,
                    ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          evoDetailAttr(evoDetails[0]),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Theme.of(context).primaryColor,
                          size: 50,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => selectedMon(context, allEvolutions[1]),
                    child: Image(
                      image: snapshot.data![1].image,
                    ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          evoDetailAttr(evoDetails[1]),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Theme.of(context).primaryColor,
                          size: 50,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => selectedMon(context, allEvolutions[2]),
                    child: Image(
                      image: snapshot.data![2].image,
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      );
    } else {
      return Text("poop");
    }
  }
}

void selectedMon(BuildContext context, String id) {
  print(id);
}

Future<List<Image>> getImage(List<String> ids, double scale) async {
  List<Image> images = [];
  for (var id in ids) {
    final response = await getData('pokemon', id);
    var data = jsonDecode(response);
    images.add(Image(
      image: NetworkImage(
        data['sprites']['other']['official-artwork']['front_default'],
        scale: 5 / scale,
      ),
    ));
  }
  return images;
}

class MovesDisplay extends StatelessWidget {
  final List moves;
  const MovesDisplay(this.moves, {super.key});

  Future<Move> fetchMove(String move) async {
    final response = await getData('move', move);    
    return Move.fromJson(jsonDecode(response));
  }

  moveDescripPopup(BuildContext context, String move) {    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColorLight,
          title: Center(
            child: Text(
              makePretty(move),
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          content: FutureBuilder<Move>(
            future: fetchMove(move),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 8,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/type_long_icons/${makePretty(snapshot.data!.type)}.svg',
                                height: MediaQuery.of(context).size.height / 30,
                                width: MediaQuery.of(context).size.width / 30,
                              ),
                              SvgPicture.asset(
                                'assets/images/attack_type/${snapshot.data!.damageClass}.svg',
                                height: MediaQuery.of(context).size.height / 30,
                                width: MediaQuery.of(context).size.width / 30,
                              ),
                            ],
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width / 40),
                          Flexible(
                            child: Text(
                              makePretty(snapshot.data!.description),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            snapshot.data!.power == 0 ? 'Power: -' :
                            'Power: ${snapshot.data!.power}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Text(
                            snapshot.data!.accuracy == 0 ? 'Accuracy: -' :
                            'Accuracy: ${snapshot.data!.accuracy}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Text(
                            snapshot.data!.pp == 0 ? 'PP: -' :
                            'PP: ${snapshot.data!.pp}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),

                        ],
                      )
                    ],
                  ),
                );
              } else if (snapshot.hasError) {                
                return Text('Error: ${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }



  // 0 - lvl up, 1 - tm, 2 - tutor, 3 - egg
  movesPopUp(BuildContext context, List movesUN, String type) {     
    Map<String, int>  moves = {};
    for (var i = 0; i < movesUN.length; i++) {
      int versionGroupDetailsLength = movesUN[i]['version_group_details'].length;
      if (movesUN[i]['version_group_details'][versionGroupDetailsLength - 1]['move_learn_method']['name'] == type) {
        if(type == 'level-up') {
          moves[movesUN[i]['move']['name']] = movesUN[i]['version_group_details'][versionGroupDetailsLength - 1]['level_learned_at'];
        } else {
          moves[movesUN[i]['move']['name']] = 0;
        }
      }
    } 
    // i want to organize the moves by level learned
    moves = Map.fromEntries(moves.entries.toList()..sort((e1, e2) => e1.value.compareTo(e2.value)));
    showDialog(
      context: context,
      builder: (BuildContext context) {        
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColorLight,
          title: Center(
            child: Text(
              "${makePretty(type)} Moves",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width / 2,
            child: ListView.builder(
              itemCount: moves.length,
              itemBuilder: (context, index) {                
                return Card(
                  color: Theme.of(context).secondaryHeaderColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => moveDescripPopup(context, moves.keys.elementAt(index)),
                      child: Text(
                        type == 'level-up' ? '${makePretty(moves.keys.elementAt(index))} - Lvl ${moves.values.elementAt(index)}' :
                        makePretty(moves.keys.elementAt(index)),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
    
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 9,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [                        
            Text(
              'Moves',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  // lvl up
                  child: GestureDetector(
                    onTap: () => movesPopUp(context, moves, 'level-up'),
                    child: Card(
                      color: Theme.of(context).secondaryHeaderColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Lvl Up',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width / 40),
                Flexible(
                  // tm
                  child: GestureDetector(
                    onTap: () => movesPopUp(context, moves, 'machine'),
                    child: Card(
                      color: Theme.of(context).secondaryHeaderColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'TM/HM',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width / 40),
                Flexible(
                  // tutor
                  child: GestureDetector(
                    onTap: () => movesPopUp(context, moves, 'tutor'),
                    child: Card(
                      color: Theme.of(context).secondaryHeaderColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Tutor',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width / 40),
                Flexible(
                  // egg
                  child: GestureDetector(
                    onTap: () => movesPopUp(context, moves, 'egg'),
                    child: Card(
                      color: Theme.of(context).secondaryHeaderColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Egg',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
