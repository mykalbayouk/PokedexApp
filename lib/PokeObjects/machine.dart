class Machine {
  final int id;
  final String name;
  final String item;
  final String move;

  Machine({
    required this.id,
    required this.name,
    required this.item,
    required this.move,
  });

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      id: json['id'],
      name: json['name'],
      item: json['item'],
      move: json['move'],
    );
  }
}