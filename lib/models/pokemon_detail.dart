class PokemonDetail {
  final int id;
  final String name;
  final List<String> types;
  final List<String> abilities;
  final String spriteUrl;

  PokemonDetail({
    required this.id,
    required this.name,
    required this.types,
    required this.abilities,
    required this.spriteUrl,
  });

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    final types = (json['types'] as List).map((t) => t['type']['name'] as String).toList();
    final abilities = (json['abilities'] as List).map((a) => a['ability']['name'] as String).toList();
    final sprite = (json['sprites']?['other']?['official-artwork']?['front_default'])
        ?? json['sprites']?['front_default']
        ?? '';
    return PokemonDetail(
      id: json['id'],
      name: json['name'],
      types: types,
      abilities: abilities,
      spriteUrl: sprite,
    );
  }
}
