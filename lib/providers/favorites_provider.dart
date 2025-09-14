import 'package:flutter/material.dart';
import '../models/pokemon_list_item.dart';

class FavoritesProvider extends ChangeNotifier {
  final Map<int, PokemonListItem> _favorites = {};

  List<PokemonListItem> get favorites => _favorites.values.toList();

  bool isFavorite(int id) => _favorites.containsKey(id);

  void toggleFavorite(PokemonListItem p) {
    if (isFavorite(p.id)) {
      _favorites.remove(p.id);
    } else {
      _favorites[p.id] = p;
    }
    notifyListeners();
  }

  void addFromDetail(int id, String name, String spriteUrl) {
    // Convenience: create a simple item if needed from details
    _favorites[id] = PokemonListItem(name: name, url: '', id: id);
    notifyListeners();
  }
}
