// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:pokedex/PokeObjects/pokemon.dart';

class PokeDetails extends StatelessWidget {
  AsyncSnapshot<Pokemon> snapshot;

  PokeDetails({super.key, required this.snapshot});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokemon Details'),
      ),
      body: Center(
        child: snapshot.connectionState == ConnectionState.done
            ? Text(snapshot.data!.name)
            : const CircularProgressIndicator(),
      ),
    );
  }
}
