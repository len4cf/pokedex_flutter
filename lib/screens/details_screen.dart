import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pokemon_list_item.dart';
import '../services/api_service.dart';
import '../models/pokemon_detail.dart';
import '../providers/favorites_provider.dart';

// Tela que exibe os detalhes de um Pokémon
class DetailsScreen extends StatefulWidget {

  final PokemonListItem pokemonListItem;
  final bool fromSearch;
  const DetailsScreen({super.key, required this.pokemonListItem, this.fromSearch = false});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  // Serviço para buscar dados da API
  final ApiService api = ApiService();
  // Future que retorna os detalhes do Pokémon
  Future<PokemonDetail>? detailFuture;

  @override
  void initState() {
    super.initState();
    // Chamada à API ao iniciar a tela para obter os detalhes do Pokémon
    detailFuture = api.fetchPokemonDetailByUrl(widget.pokemonListItem.url);
  }

  @override
  Widget build(BuildContext context) {
    final favProv = Provider.of<FavoritesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pokemonListItem.name.toUpperCase()),
        actions: [
          // Botão de favorito na AppBar
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
            // Enquanto aguarda resposta da API
            return const Center(child: CircularProgressIndicator());
          } 
            // Caso ocorra algum erro na requisição
            else if (snap.hasError) {
            return Center(child: Text('Erro: ${snap.error}'));
          } 
            // Se a API não retornou dados
            else if (!snap.hasData) {
            return const Center(child: Text('Sem dados'));
          }
          final detail = snap.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                // Exibe ID e nome do Pokémon formatado
                if (detail.spriteUrl.isNotEmpty)
                  Image.network(detail.spriteUrl, height: 200),
                const SizedBox(height: 12),

                // Exibe ID e nome do Pokémon formatado
                Text('#${detail.id}  ${detail.name[0].toUpperCase() + detail.name.substring(1)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),

                // Lista de tipos do Pokémon exibida em Chips
                Wrap(
                  spacing: 8,
                  children: detail.types.map((t) => Chip(label: Text(t))).toList(),
                ),

                const SizedBox(height: 12),
                const Align(alignment: Alignment.centerLeft, child: Text('Habilidades:', style: TextStyle(fontWeight: FontWeight.bold))),
                const SizedBox(height: 6),

                // Lista de habilidades do Pokémon
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: detail.abilities.map((a) => Text('- $a')).toList(),
                ),
                const SizedBox(height: 20),

                // Botão para alternar favorito/desfavorito
                ElevatedButton.icon(
                  onPressed: () {
                    final simple = widget.pokemonListItem;
                    // Alterna status no provider sem escutar mudanças
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
