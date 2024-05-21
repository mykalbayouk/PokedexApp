class Species {
  final String evolutionChainID;
  final List<dynamic> flavorTextEntries;
  final String genus;

  Species({
    required this.evolutionChainID,
    required this.flavorTextEntries,
    required this.genus,
  });

  factory Species.fromJson(Map<String, dynamic> json) {
    return Species(
      evolutionChainID: json['evolution_chain']['url'].split('/')[6],
      // i only want to save the english flavor text entries
      flavorTextEntries: json['flavor_text_entries']
          .where((entry) => entry['language']['name'] == 'en')
          .map((entry) => entry['flavor_text'])
          .toList(),
      genus: json['genera'][7]['genus'],
    );
  }
}