import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pokemon_list_item.dart';
import '../services/api_service.dart';
import '../models/pokemon_detail.dart';
import '../providers/favorites_provider.dart';

class DetailsScreen extends StatefulWidget {
  final PokemonListItem pokemonListItem;
  final bool fromSearch;
  const DetailsScreen({super.key, required this.pokemonListItem, this.fromSearch = false});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final ApiService api = ApiService();
  Future<PokemonDetail>? detailFuture;

  @override
  void initState() {
    super.initState();
    detailFuture = api.fetchPokemonDetailByUrl(widget.pokemonListItem.url);
  }

  @override
  Widget build(BuildContext context) {
    final favProv = Provider.of<FavoritesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pokemonListItem.name.toUpperCase()),
        actions: [
          Consumer<FavoritesProvider>(
            builder: (_, prov, __) {
              final isFav = prov.isFavorite(widget.pokemonListItem.id);
              return IconButton(
                icon: Icon(isFav ? Icons.star : Icons.star_border),
                onPressed: () {
                  prov.toggleFavorite(widget.pokemonListItem);
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<PokemonDetail>(
        future: detailFuture,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snap.hasError) {
            return Center(child: Text('Erro: ${snap.error}'));
          } else if (!snap.hasData) {
            return const Center(child: Text('Sem dados'));
          }
          final detail = snap.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (detail.spriteUrl.isNotEmpty)
                  Image.network(detail.spriteUrl, height: 200),
                const SizedBox(height: 12),
                Text('#${detail.id}  ${detail.name[0].toUpperCase() + detail.name.substring(1)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: detail.types.map((t) => Chip(label: Text(t))).toList(),
                ),
                const SizedBox(height: 12),
                const Align(alignment: Alignment.centerLeft, child: Text('Habilidades:', style: TextStyle(fontWeight: FontWeight.bold))),
                const SizedBox(height: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: detail.abilities.map((a) => Text('- $a')).toList(),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    final simple = widget.pokemonListItem;
                    Provider.of<FavoritesProvider>(context, listen: false).toggleFavorite(simple);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Status de favorito alterado')));
                  },
                  icon: const Icon(Icons.star),
                  label: const Text('Favoritar / Desfavoritar'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
