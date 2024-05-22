/// EvoDetails class, stores:
/// gender, heldItem, item, knownMove, knownMoveType, location, minAffection,
/// minBeauty, minHappiness, minLevel, needsOverworldRain, partySpecies,
/// partyType, relativePhysicalStats, timeOfDay, tradeSpecies, turnUpsideDown,
/// and trigger.
class EvoDetails {
  late var gender;
  late var heldItem;
  late var item;
  late var knownMove;
  late var knownMoveType;
  late var location;
  late var minAffection;
  late var minBeauty;
  late var minHappiness;
  late var minLevel;
  late var needsOverworldRain;
  late var partySpecies;
  late var partyType;
  late var relativePhysicalStats;
  late var timeOfDay;
  late var tradeSpecies;
  late var turnUpsideDown;
  late var trigger;

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
      gender: json['gender'] ?? '',
      heldItem: json['held_item'] ?? '',
      item: json['item'] ?? '',
      knownMove: json['known_move'] ?? '',
      knownMoveType: json['known_move_type'] ?? '',
      location: json['location'] ?? '',
      minAffection: json['min_affection'] ?? '',
      minBeauty: json['min_beauty'] ?? '',
      minHappiness: json['min_happiness'] ?? '',
      minLevel: json['min_level'] ?? '',
      needsOverworldRain: json['needs_overworld_rain'] ?? '',
      partySpecies: json['party_species'] ?? '',
      partyType: json['party_type'] ?? '',
      relativePhysicalStats: json['relative_physical_stats'] ?? '',
      timeOfDay: json['time_of_day'] ?? '',
      tradeSpecies: json['trade_species'] ?? '',
      turnUpsideDown: json['turn_upside_down'] ?? '',
      trigger: json['trigger']['name'] ?? '',
    );
  }

  void printDetails() {
    print("gender: $gender \n"
        "heldItem: $heldItem \n"
        "item: $item \n"
        "knownMove: $knownMove \n"
        "knownMoveType: $knownMoveType \n"
        "location: $location \n"
        "minAffection: $minAffection \n"
        "minBeauty: $minBeauty \n"
        "minHappiness: $minHappiness \n"
        "minLevel: $minLevel \n"
        "needsOverworldRain: $needsOverworldRain \n"
        "partySpecies: $partySpecies \n"
        "partyType: $partyType \n"
        "relativePhysicalStats: $relativePhysicalStats \n"
        "timeOfDay: $timeOfDay \n"
        "tradeSpecies: $tradeSpecies \n"
        "turnUpsideDown: $turnUpsideDown \n"
        "trigger: $trigger \n");
  }

}