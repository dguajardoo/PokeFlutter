import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/pokemon.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonCard({super.key, required this.pokemon});

  // Colores por tipo de pokémon
  Color _getTypeColor(String type) {
    final colors = {
      'fire': Colors.orange,
      'water': Colors.blue,
      'grass': Colors.green,
      'electric': Colors.yellow.shade700,
      'psychic': Colors.pink,
      'ice': Colors.cyan,
      'dragon': Colors.indigo,
      'dark': Colors.brown,
      'fairy': Colors.pinkAccent,
      'fighting': Colors.red.shade800,
      'poison': Colors.purple,
      'ground': Colors.amber,
      'rock': Colors.grey,
      'bug': Colors.lightGreen,
      'ghost': Colors.deepPurple,
      'steel': Colors.blueGrey,
      'normal': Colors.grey.shade400,
      'flying': Colors.lightBlue,
    };
    return colors[type] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    // Color de fondo basado en el primer tipo
    final cardColor = _getTypeColor(
      pokemon.types.isNotEmpty ? pokemon.types.first : 'normal',
    );

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              cardColor.withOpacity(1),
              cardColor.withOpacity(1),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Número del pokémon
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  '#${pokemon.id.toString().padLeft(3, '0')}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Imagen con caché
              // Equivalente a Coil/Glide en Android
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: pokemon.imageUrl,
                  placeholder: (context, url) => const Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) =>
                  const Icon(Icons.catching_pokemon, size: 48),
                ),
              ),

              const SizedBox(height: 8),

              // Nombre
              Text(
                pokemon.name.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 6),

              // Tipos
              Wrap(
                spacing: 4,
                children: pokemon.types.map((type) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      type.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}