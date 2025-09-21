// Classe que representa os detalhes de um Pokémon
class PokemonDetail {
  final int id;
  final String name;
  final List<String> types;
  final List<String> abilities;
  final String spriteUrl;

// Construtor da classe
  PokemonDetail({
    required this.id,
    required this.name,
    required this.types,
    required this.abilities,
    required this.spriteUrl,
  });

  // Factory constructor que cria um objeto PokemonDetail a partir de um JSON
  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    
    // Mapeia a lista de tipos do JSON para uma lista de strings
    final types = (json['types'] as List).map((t) => t['type']['name'] as String).toList();

    // Mapeia a lista de habilidades do JSON para uma lista de strings
    final abilities = (json['abilities'] as List).map((a) => a['ability']['name'] as String).toList();

    // Tenta pegar a imagem oficial do Pokémon
    final sprite = (json['sprites']?['other']?['official-artwork']?['front_default'])
        ?? json['sprites']?['front_default']
        ?? '';

    // Retorna um objeto PokemonDetail com os valores extraídos do JSON
    return PokemonDetail(
      id: json['id'],
      name: json['name'],
      types: types,
      abilities: abilities,
      spriteUrl: sprite,
    );
  }
}
