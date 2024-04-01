import 'package:flutter/material.dart';
import 'package:pokedex/Utilities/Functions/string_extension.dart';

class AbilitiesList extends StatelessWidget {
  final List abilities;
  const AbilitiesList(this.abilities, {super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          for (var ability in abilities)
            Text(
              ability['ability']['name'].toString().capitalize(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
        ],
      ),
    );
  }
}