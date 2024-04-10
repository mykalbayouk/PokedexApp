// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:pokedex/PokeObjects/pokemon.dart';
import 'package:pokedex/Utilities/CustomWidgets/abilities_list.dart';
import 'package:pokedex/Utilities/CustomWidgets/custom_text.dart';
import 'package:pokedex/Utilities/Functions/api.dart';
import 'package:pokedex/Utilities/Functions/dex_type.dart';
import 'package:pokedex/Utilities/CustomWidgets/pokeimage.dart';
import 'package:pokedex/Utilities/Functions/string_extension.dart';
import 'package:pokedex/pokeobjects/evolution.dart';
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

Future<Evolution> fetchEvolutionChain(String id) async {
  final response = await getData('evolution-chain', id);
  return Evolution.fromJson(jsonDecode(response));
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
          title: CardText(
            "Details",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          content: speciesBuilder(widget.snapshot.data!.id.toString(), widget.snapshot.data!.height, widget.snapshot.data!.weight),
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
                      SizedBox(height: MediaQuery.of(context).size.height / 40),
                      PokeType(widget.snapshot.data!.types),
                    ],
                  ),
                ],                
              ),                  
              AbilitiesList(widget.snapshot.data!.abilities),     
              SizedBox(height: MediaQuery.of(context).size.height / 40),
              EvolutionDisplay(id: widget.snapshot.data!.id.toString()),                
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
                  makePretty(snapshot.data!.flavorTextEntries[Random().nextInt(snapshot.data!.flavorTextEntries.length)]),
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
          // need to update to show what strong and weak against
          content: SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var type in types)
                  Image(
                    image: Svg(
                        'assets/images/type_long_icons/${fixy(type['type']['name'])}.svg'),
                  ),
              ],
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
    return GestureDetector(
      onTap: () {
        typePopUp(context, types);
      },
      child: SizedBox(
        child: Column(
          children: [
            for (var type in types)
              Image(
                image: Svg(
                    'assets/images/type_long_icons/${fixy(type['type']['name'])}.svg'),
              ),
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
          return FutureBuilder<Evolution>(
            future: fetchEvolutionChain(snapshot.data!.evolutionChainID),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text('${snapshot.data!.start} -> ${snapshot.data!.middle} -> ${snapshot.data!.end}');                
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

  