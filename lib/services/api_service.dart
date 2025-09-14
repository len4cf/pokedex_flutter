import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon_list_item.dart';
import '../models/pokemon_detail.dart';

class ApiService {
  static const baseUrl = 'https://pokeapi.co/api/v2';

  Future<Map<String, dynamic>> fetchPokemonPage({int limit = 20, int offset = 0}) async {
    final uri = Uri.parse('$baseUrl/pokemon?limit=$limit&offset=$offset');
    final resp = await http.get(uri);
    if (resp.statusCode != 200) throw Exception('Falha ao buscar lista de pokémon');
    return jsonDecode(resp.body) as Map<String, dynamic>;
  }

  Future<List<PokemonListItem>> fetchPokemonList({int limit = 20, int offset = 0}) async {
    final json = await fetchPokemonPage(limit: limit, offset: offset);
    final results = (json['results'] as List).map((e) => PokemonListItem.fromJson(e)).toList();
    return results;
  }

  Future<PokemonDetail> fetchPokemonDetailByUrl(String url) async {
    final uri = Uri.parse(url);
    final resp = await http.get(uri);
    if (resp.statusCode != 200) throw Exception('Falha ao buscar detalhe do pokémon');
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    return PokemonDetail.fromJson(json);
  }

  Future<PokemonDetail> fetchPokemonDetailByNameOrId(String query) async {
    final uri = Uri.parse('$baseUrl/pokemon/${query.toLowerCase()}');
    final resp = await http.get(uri);
    if (resp.statusCode != 200) throw Exception('Pokémon não encontrado');
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    return PokemonDetail.fromJson(json);
  }
}
