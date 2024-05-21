class Pokedex {
  final String description;

  Pokedex({
    required this.description,
  });

  factory Pokedex.fromJson(Map<String, dynamic> json) {
    return Pokedex(
      description: json['descriptions']
          .firstWhere((entry) => entry['language']['name'] == 'en')['description'],
    );
  }
}