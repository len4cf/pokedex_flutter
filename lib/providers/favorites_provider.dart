import 'package:flutter/material.dart';
import '../models/pokemon_list_item.dart';

// Provider para gerenciar os Pokémons favoritos
class FavoritesProvider extends ChangeNotifier {

  // Mapa que armazena os Pokémons favoritos pelo ID
  final Map<int, PokemonListItem> _favorites = {};

  // Retorna a lista de Pokémons favoritos
  List<PokemonListItem> get favorites => _favorites.values.toList();

  bool isFavorite(int id) => _favorites.containsKey(id);

  // Adiciona ou remove um Pokémon dos favoritos
  void toggleFavorite(PokemonListItem p) {
    if (isFavorite(p.id)) {
      _favorites.remove(p.id);
    } else {
      _favorites[p.id] = p;
    }
    notifyListeners();
  }

  // Adiciona um Pokémon aos favoritos usando apenas detalhes mínimos
  void addFromDetail(int id, String name, String spriteUrl) {
    // Cria um item simples a partir dos detalhes
    _favorites[id] = PokemonListItem(name: name, url: '', id: id);
    notifyListeners();
  }
}
