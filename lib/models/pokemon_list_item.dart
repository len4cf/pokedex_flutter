class PokemonListItem {
  final String name;
  final String url;
  final int id;

  PokemonListItem({
    required this.name,
    required this.url,
    required this.id,
  });

  factory PokemonListItem.fromJson(Map<String, dynamic> json) {
    final url = json['url'] as String;
    final id = _extractIdFromUrl(url);
    return PokemonListItem(
      name: json['name'],
      url: url,
      id: id,
    );
  }

  static int _extractIdFromUrl(String url) {
    final parts = url.split('/');
    for (var i = parts.length - 1; i >= 0; i--) {
      if (parts[i].isNotEmpty) return int.parse(parts[i]);
    }
    return 0;
  }

  String get spriteUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
}
