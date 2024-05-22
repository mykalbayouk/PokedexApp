import 'package:pokedex/pokeobjects/evo_details.dart';
import 'package:pokedex/pokeobjects/evolution.dart';

/// A class that represents the evolution chain of a Pokemon, including the
/// species and details of the evolution.
class Chain {
  final List<Chain> evolvesTo;
  final Evolution species;
  final List<EvoDetails> details;

  Chain({
    required this.evolvesTo,
    required this.details,
    required this.species,
  });

  factory Chain.fromJson(Map<String, dynamic> json) {
    return Chain(
      evolvesTo: json['evolves_to'] != null
          ? (json['evolves_to'] as List)
              .map((e) => Chain.fromJson(e))
              .toList()
          : [],
      details: json['evolution_details'] != null
          ? (json['evolution_details'] as List)
              .map((e) => EvoDetails.fromJson(e))
              .toList()
          : [],
      species: Evolution.fromJson(json['species']),
    );
  }

  List<String> get allEvolutions {
    List<String> evolutions = [];
    evolutions.add(this.species.name);
    for (Chain evo in evolvesTo) {
      evolutions.addAll(evo.allEvolutions);
    }
    return evolutions;
  }

  List<EvoDetails> get allDetails {
    List<EvoDetails> details = [];
    details.addAll(this.details);
    for (Chain evo in evolvesTo) {
      details.addAll(evo.allDetails);
    }
    return details;
  }
}