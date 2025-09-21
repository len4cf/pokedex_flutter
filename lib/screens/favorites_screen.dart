import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/pokemon_card.dart';
import 'details_screen.dart';

// Tela que exibe a lista de Pokémons favoritados
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Acesso ao provider de favoritos
    final favProv = Provider.of<FavoritesProvider>(context);
    final favs = favProv.favorites;

    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: favs.isEmpty
        // Caso não haja favoritos, exibe mensagem
        ? const Center(child: Text('Nenhum pokémon favoritado'))
        // Caso haja favoritos, exibe em Grid
        : GridView.builder(
            padding: const EdgeInsets.all(8),
            // Configuração do grid: 2 colunas e proporção dos cards
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.9),
            itemCount: favs.length,
            itemBuilder: (context, idx) {
              final p = favs[idx];
              return PokemonCard(
                pokemon: p,
                // Ao clicar, navega para a tela de detalhes
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailsScreen(pokemonListItem: p))),
              );
            },
          ),
    );
  }
}
