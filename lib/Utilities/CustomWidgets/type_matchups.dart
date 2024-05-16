import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex/Utilities/Functions/api.dart';
import 'package:pokedex/Utilities/Functions/type_color.dart';
import 'package:pokedex/pokeobjects/type.dart';
import 'package:pokedex/Utilities/Functions/string_extension.dart';

class TypeMatchups extends StatelessWidget {
  final List<dynamic> types;

  const TypeMatchups(this.types, {super.key});

  Future<List<PokeType>> fetchType(List<String> url) async {
    List<PokeType> typeList = [];
    for (var i = 0; i < url.length; i++) {
      final response = await getData('type', url[i]);
      typeList.add(PokeType.fromJson(jsonDecode(response)));
    }
    return typeList;
  }

  void organizeMatchups(List<PokeType> data, Map<String, List> matchups,
      Map<String, bool> superType) {
    for (var i = 0; i < data.length; i++) {
      List<String> doubleDamageFrom = [];
      List<String> halfDamageFrom = [];
      List<String> noDamageFrom = [];

      for (var j = 0; j < data[i].doubleDamageFrom.length; j++) {
        doubleDamageFrom.add(data[i].doubleDamageFrom[j]['name']);
      }
      for (var j = 0; j < data[i].halfDamageFrom.length; j++) {
        halfDamageFrom.add(data[i].halfDamageFrom[j]['name']);
      }
      for (var j = 0; j < data[i].noDamageFrom.length; j++) {
        noDamageFrom.add(data[i].noDamageFrom[j]['name']);
      }
      //make sure that the matchups damge from does not have any duplicates from half damage and no damage from

      matchups['doubleDamageFrom']?.addAll(doubleDamageFrom);
      matchups['halfDamageFrom']?.addAll(halfDamageFrom);
      matchups['noDamageFrom']?.addAll(noDamageFrom);
    }

    List<String> removedItems = [];
    for (var i = 0; i < matchups['doubleDamageFrom']!.length; i++) {
      if (matchups['halfDamageFrom']!
              .contains(matchups['doubleDamageFrom']?[i]) ||
          matchups['noDamageFrom']!
              .contains(matchups['doubleDamageFrom']?[i])) {
        removedItems.add(matchups['doubleDamageFrom']?[i]);
      }
    }
    for (var x = 0; x < matchups['noDamageFrom']!.length; x++) {
      if (matchups['halfDamageFrom']!
              .contains(matchups['noDamageFrom']?[x])) {
        matchups['halfDamageFrom']!.remove(matchups['noDamageFrom']?[x]);      
      } else if (matchups['doubleDamageFrom']!
              .contains(matchups['noDamageFrom']?[x])) {
        matchups['doubleDamageFrom']!.remove(matchups['noDamageFrom']?[x]);
      }      
    }
    matchups['doubleDamageFrom']
        ?.removeWhere((element) => removedItems.contains(element));
    matchups['halfDamageFrom']
        ?.removeWhere((element) => removedItems.contains(element));
    matchups['noDamageFrom']
        ?.removeWhere((element) => removedItems.contains(element));

    matchups['doubleDamageFrom']!.forEach((element) {
      int count = 0;
      for (var i = 0; i < matchups['doubleDamageFrom']!.length; i++) {
        if (element == matchups['doubleDamageFrom']![i]) {
          count++;
        }
        if (count > 1) {
          superType[element] = true;
        }
      }
    });
    matchups['halfDamageFrom']!.forEach((element) {
      int count = 0;
      for (var i = 0; i < matchups['halfDamageFrom']!.length; i++) {
        if (element == matchups['halfDamageFrom']![i]) {
          count++;
        }
        if (count > 1) {
          superType[element] = true;
        }
      }
    });
    for (int i = 0; i < superType.keys.length; i++) {
      matchups['doubleDamageFrom']!.remove(superType.keys.toList()[i]);
      matchups['halfDamageFrom']!.remove(superType.keys.toList()[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> url = [];
    for (var i = 0; i < types.length; i++) {
      // i only need the number at the end of the url
      url.add(types[i]['type']['url']
          .replaceAll('https://pokeapi.co/api/v2/type/', '')
          .replaceAll('/', ''));
    }
    return FutureBuilder<List<PokeType>>(
      future: fetchType(url),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map<String, List> matchups = {
            'doubleDamageFrom': [],
            'halfDamageFrom': [],
            'noDamageFrom': [],
          };
          Map<String, bool> superType = {};
          organizeMatchups(snapshot.data!, matchups, superType);
          return SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [                
                Column(
                  children: [
                    Text(
                      "2x",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    for (var i = 0;
                        i < matchups['doubleDamageFrom']!.length;
                        i++)
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    superType[matchups['doubleDamageFrom']![i]] ==
                                            true
                                        ? Theme.of(context).primaryColor
                                        : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: SvgPicture.asset(
                              'assets/images/type_short_icons/${makePretty(matchups['doubleDamageFrom']![i])}.svg',
                              height: MediaQuery.of(context).size.height / 10,
                              width: MediaQuery.of(context).size.width / 10,
                              color: chooseColor(
                                  makePretty(matchups['doubleDamageFrom']![i])),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "0.5x",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    for (var i = 0; i < matchups['halfDamageFrom']!.length; i++)
                      Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  superType[matchups['halfDamageFrom']![i]] ==
                                          true
                                      ? Theme.of(context).primaryColor
                                      : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: SvgPicture.asset(
                              'assets/images/type_short_icons/${makePretty(matchups['halfDamageFrom']![i])}.svg',
                              height: MediaQuery.of(context).size.height / 10,
                              width: MediaQuery.of(context).size.width / 10,
                              color: chooseColor(
                                  makePretty(matchups['halfDamageFrom']![i]))),
                        ),
                      ),
                  ],
                ),
                if (matchups['noDamageFrom']!.length > 0)
                  Column(
                    children: [
                      Text(
                        "0x",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      for (var i = 0; i < matchups['noDamageFrom']!.length; i++)
                        Flexible(
                          child: SvgPicture.asset(
                              'assets/images/type_short_icons/${makePretty(matchups['noDamageFrom']![i])}.svg',
                              height: MediaQuery.of(context).size.height / 10,
                              width: MediaQuery.of(context).size.width / 10,
                              color: chooseColor(
                                  makePretty(matchups['noDamageFrom']![i]))),
                        ),
                    ],
                  ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Text('Error: ${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
