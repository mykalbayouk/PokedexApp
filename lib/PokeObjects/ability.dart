class Ability {
  final String name;
  final String description;

  Ability({required this.name, required this.description});

  factory Ability.fromJson(Map<String, dynamic> json) {
    return Ability(
      name: json['name'],
      // i need to make sure the language is english
      description: [
        for (var entry in json['effect_entries'])
          if (entry['language']['name'] == 'en') entry['effect']
      ][0],
    );
  }
}
