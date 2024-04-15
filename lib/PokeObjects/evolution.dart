
class Evolution {
  final String name;

  Evolution({
    required this.name,
  });

  factory Evolution.fromJson(Map<String, dynamic> json) {
    return Evolution(
      name: json['name'],
    );
  }


}