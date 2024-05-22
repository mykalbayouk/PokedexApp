import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokedex/Utilities/CustomWidgets/custom_progress.dart';
import 'package:pokedex/Utilities/CustomWidgets/custom_text.dart';
import 'package:pokedex/Utilities/Functions/api.dart';
import 'package:pokedex/Utilities/Functions/string_extension.dart';
import 'package:pokedex/pokeobjects/ability.dart';

/// A wiudget that represents the list of abilities of a Pokemon.
class AbilitiesList extends StatelessWidget {
  final List abilities;
  const AbilitiesList(this.abilities, {super.key});

/// Fetches the ability from the API.
  Future<Ability> fetchAbility(String url) async {
    url = url.replaceAll('https://pokeapi.co/api/v2/ability/', '').replaceAll('/', '');    
    final response = await getData('ability', url);
    return Ability.fromJson(jsonDecode(response));
  }
/// Makes the ability name pretty.
  void abilityPopUp(BuildContext context, String ability, String url, bool isHidden) {    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          title: Text(makePretty(ability),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              )
          ),
          // Builds the ability description.
          content: FutureBuilder<Ability>(
            future: fetchAbility(url),
            builder: (context, snapshot) {
              if (snapshot.hasData) {                
                return Text(
                  // If the ability is hidden, display 'HIDDEN ABILITY' before the description.
                  isHidden ? 'HIDDEN ABILITY\n\n${snapshot.data!.description}' :
                  snapshot.data!.description,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).primaryColor,
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              return customProgressIndicator(context, Theme.of(context).secondaryHeaderColor);   
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
  /// Builds AbilitiesList widget.
  @override
  Widget build(BuildContext context) {
    return Card(      
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Text(
              'Abilities: ',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),             
            // for each ability, build a card with the ability name.
            for (var ability in abilities)
              Flexible(
                child: GestureDetector(
                  onTap: () => abilityPopUp(context, ability['ability']['name'].toString().capitalize(), ability['ability']['url'], ability['is_hidden']),
                  child: CardText(
                    makePretty(ability['ability']['name'].toString().capitalize()),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: ability['is_hidden'] ? Theme.of(context).primaryColorDark : Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),              
          ],
        ),
      ),
    );
  }


  
}
