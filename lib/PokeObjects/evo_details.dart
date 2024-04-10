class EvoDetails {
  final String gender;
  final String heldItem;
  final String item;
  final String knownMove;
  final String knownMoveType;
  final String location;
  final String minAffection;
  final String minBeauty;
  final String minHappiness;
  final String minLevel;
  final String needsOverworldRain;
  final String partySpecies;
  final String partyType;
  final String relativePhysicalStats;
  final String timeOfDay;
  final String tradeSpecies;
  final String turnUpsideDown;
  final String trigger;

  EvoDetails({
    required this.gender,
    required this.heldItem,
    required this.item,
    required this.knownMove,
    required this.knownMoveType,
    required this.location,
    required this.minAffection,
    required this.minBeauty,
    required this.minHappiness,
    required this.minLevel,
    required this.needsOverworldRain,
    required this.partySpecies,
    required this.partyType,
    required this.relativePhysicalStats,
    required this.timeOfDay,
    required this.tradeSpecies,
    required this.turnUpsideDown,
    required this.trigger,
  });

  factory EvoDetails.fromJson(Map<String, dynamic> json) {
    return EvoDetails(
      gender: json['gender'],
      heldItem: json['held_item'],
      item: json['item'],
      knownMove: json['known_move'],
      knownMoveType: json['known_move_type'],
      location: json['location'],
      minAffection: json['min_affection'],
      minBeauty: json['min_beauty'],
      minHappiness: json['min_happiness'],
      minLevel: json['min_level'],
      needsOverworldRain: json['needs_overworld_rain'],
      partySpecies: json['party_species'],
      partyType: json['party_type'],
      relativePhysicalStats: json['relative_physical_stats'],
      timeOfDay: json['time_of_day'],
      tradeSpecies: json['trade_species'],
      turnUpsideDown: json['turn_upside_down'],
      trigger: json['trigger']['name'],
    );
  }

}