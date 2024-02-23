class Region {
  final String name;
  final int id;
  final List locations;

  Region({
    required this.name,
    required this.id,
    required this.locations,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      name: json['name'],
      id: json['id'],
      locations: json['locations'],
    );
  }

}