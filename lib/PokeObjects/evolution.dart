import 'package:pokedex/pokeobjects/evo_details.dart';

class Evolution {
  final String start;
  final String middle;
  final String end;
  //final List<EvoDetails> details;

  Evolution({
    required this.start,
    required this.middle,
    required this.end,
   // required this.details,
  });

  factory Evolution.fromJson(Map<String, dynamic> json) {
    return Evolution(
      start: json['chain']['species']['name'],
      middle: json['chain']['evolves_to'][0]['species']['name'],
      end: json['chain']['evolves_to'][0]['evolves_to'][0]['species']['name'],
      // details: json['chain']['evolves_to'][0]['evolves_to'][0]['evolution_details']
      //     .map<EvoDetails>((details) => EvoDetails.fromJson(details))
      //     .toList(),
    );
  }
}