/// This class is used to create a Move object, which is used to store the data of a move.
/// The data stored includes the name, accuracy, power, pp, type, damage class, and description of the move.
class Move {
  final String name;  
  final int accuracy;
  final int power;
  final int pp;
  final String type;
  final String damageClass;
  final String description;

  Move({
    required this.name,    
    required this.accuracy,
    required this.power,
    required this.pp,
    required this.type,
    required this.damageClass,
    required this.description,
  });

  factory Move.fromJson(Map<String, dynamic> json) {
    return Move(
      name: json['name'],      
      accuracy: json['accuracy'] ?? 0,
      power: json['power'] ?? 0,
      pp: json['pp'] ?? 0,
      type: json['type']['name'],
      damageClass: json['damage_class']['name'],
      // i need to make sure its the english version of the description, i only need it once
      description: json['flavor_text_entries']
          .firstWhere((entry) => entry['language']['name'] == 'en')['flavor_text'],
    );
  }
}