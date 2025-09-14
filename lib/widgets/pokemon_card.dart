import 'package:flutter/material.dart';
import '../models/pokemon_list_item.dart';

class PokemonCard extends StatelessWidget {
  final PokemonListItem pokemon;
  final VoidCallback onTap;
  const PokemonCard({super.key, required this.pokemon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: pokemon.spriteUrl.isNotEmpty
                ? Image.network(pokemon.spriteUrl, fit: BoxFit.contain)
                : const SizedBox.shrink(),
            ),
            const SizedBox(height: 4),
            Text(
              pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}
