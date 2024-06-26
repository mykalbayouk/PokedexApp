/// This class is used to create a PokeType object that is used to store the data of a type of pokemon.
class PokeType {
  final String name;
  final int id;
  final List doubleDamageFrom;
  final List doubleDamageTo;
  final List halfDamageFrom;
  final List halfDamageTo;
  final List noDamageFrom;
  final List noDamageTo;
  final List pokemon;
  final List moves;

  PokeType({
    required this.name,
    required this.id,
    required this.doubleDamageFrom,
    required this.doubleDamageTo,
    required this.halfDamageFrom,
    required this.halfDamageTo,
    required this.noDamageFrom,
    required this.noDamageTo,
    required this.pokemon,
    required this.moves,
  });

  factory PokeType.fromJson(Map<String, dynamic> json) {
    return PokeType(
      name: json['name'],
      id: json['id'],
      doubleDamageFrom: json['damage_relations']['double_damage_from'],
      doubleDamageTo: json['damage_relations']['double_damage_to'],
      halfDamageFrom: json['damage_relations']['half_damage_from'],
      halfDamageTo: json['damage_relations']['half_damage_to'],
      noDamageFrom: json['damage_relations']['no_damage_from'],
      noDamageTo: json['damage_relations']['no_damage_to'],
      pokemon: json['pokemon'],
      moves: json['moves'],
    );
  }

}


