class Versions {
  final String game;
  final String method;

  Versions({
    required this.game,
    required this.method,
  });

  factory Versions.fromJson(Map<String, dynamic> json) {
    return Versions(
      game: json['version']['name'],
      method: json['encounter_details'][0]['method']['name'],
    );
  }
  
}