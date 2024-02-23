

class Move {
  final String name;
  final int id;
  final int accuracy;
  final int power;
  final int pp;
  final String type;
  final String damageClass;
  final String effect;

  Move({
    required this.name,
    required this.id,
    required this.accuracy,
    required this.power,
    required this.pp,
    required this.type,
    required this.damageClass,
    required this.effect,
  });

  factory Move.fromJson(Map<String, dynamic> json) {
    return Move(
      name: json['name'],
      id: json['id'],
      accuracy: json['accuracy'],
      power: json['power'],
      pp: json['pp'],
      type: json['type']['name'],
      damageClass: json['damage_class']['name'],
      effect: json['effect_entries'][0]['effect'],
    );
  }
}