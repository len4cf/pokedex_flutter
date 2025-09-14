import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/pokemon_card.dart';
import 'details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favProv = Provider.of<FavoritesProvider>(context);
    final favs = favProv.favorites;
    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: favs.isEmpty
        ? const Center(child: Text('Nenhum pokémon favoritado'))
        : GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.9),
            itemCount: favs.length,
            itemBuilder: (context, idx) {
              final p = favs[idx];
              return PokemonCard(
                pokemon: p,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailsScreen(pokemonListItem: p))),
              );
            },
          ),
    );
  }
}
