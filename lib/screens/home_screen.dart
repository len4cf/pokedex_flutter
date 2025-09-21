import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/pokemon_list_item.dart';
import '../widgets/pokemon_card.dart';
import 'details_screen.dart';
import 'favorites_screen.dart';

// Tela principal que exibe a lista de Pokémons e permite busca
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService api = ApiService();           // Serviço para chamar a API
  final List<PokemonListItem> pokemons = [];     // Lista de Pokémons carregados
  bool loading = false;                          // Indica se está carregando dados
  bool error = false;                            // Indica se ocorreu erro na requisição
  int offset = 0;                                // Offset para paginação
  final int limit = 20;                          // Número de Pokémons por página

  // Controller da busca
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMore();
  }

  // Função para carregar mais Pokémons (paginado)
  Future<void> _loadMore() async {
    setState(() {
      loading = true;
      error = false;
    });
    try {
      final list = await api.fetchPokemonList(limit: limit, offset: offset);
      setState(() {
        pokemons.addAll(list);
        offset += limit;
      });
    } catch (e) {
      setState(() {
        error = true;
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  // Função de busca de Pokémon por nome ou ID
  Future<void> _search() async {
    final query = searchController.text.trim();
    if (query.isEmpty) return;
    setState(() {
      loading = true;
      error = false;
    });
    try {
      final detail = await api.fetchPokemonDetailByNameOrId(query);
      if (!mounted) return; // Verifica se o widget ainda está montado
      // Navega para tela de detalhes do Pokémon encontrado
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailsScreen(
            pokemonListItem: PokemonListItem(
              name: detail.name,
              url: '${ApiService.baseUrl}/pokemon/${detail.id}/',
              id: detail.id,
            ),
            fromSearch: true,
          ),
        ),
      );
    } catch (e) {
      // Mostra mensagem caso Pokémon não seja encontrado
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pokémon não encontrado')),
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], 

      // AppBar com título e botão para favoritos
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Pokédex Explorer',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.star, color: Colors.amber),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoritesScreen()),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // Campo de busca
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Buscar Pokémon por nome ou ID",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _search(),
            ),
          ),

          // Lista de pokémons
          Expanded(
            child: error
                ? const Center(
                    child: Text(
                      'Erro ao carregar. Tente novamente.',
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: pokemons.length,
                    itemBuilder: (context, index) {
                      final p = pokemons[index];
                      return PokemonCard(
                        pokemon: p,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailsScreen(pokemonListItem: p),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Indicador de carregamento
          if (loading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),

          // Botão "Carregar Mais" para paginação manual
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: loading ? null : _loadMore,
              child: const Text(
                'Carregar Mais',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
