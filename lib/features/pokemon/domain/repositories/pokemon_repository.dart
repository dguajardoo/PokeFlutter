import '../entities/pokemon.dart';

// Interfaz — equivalente a tu interface en Kotlin
abstract class PokemonRepository {
  // Trae lista paginada de pokémon
  Future<List<Pokemon>> getPokemonList({
    int limit = 20,
    int offset = 0,
  });

  // Trae detalle de un pokémon por ID
  Future<Pokemon> getPokemonDetail(int id);
}