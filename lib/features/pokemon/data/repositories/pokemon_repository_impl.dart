import '../../domain/entities/pokemon.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../datasources/pokemon_remote_datasource.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDatasource _datasource;

  PokemonRepositoryImpl({PokemonRemoteDatasource? datasource})
      : _datasource = datasource ?? PokemonRemoteDatasource();

  @override
  Future<List<Pokemon>> getPokemonList({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      // 1. Trae la lista básica (nombre + URL)
      final listItems = await _datasource.getPokemonList(
        limit: limit,
        offset: offset,
      );

      // 2. Por cada item, trae el detalle completo
      // Future.wait es equivalente a async/await en paralelo
      // Como launch{} + awaitAll en Kotlin coroutines
      final pokemons = await Future.wait(
        listItems.map((item) => _datasource.getPokemonDetail(item.id)),
      );

      // 3. Convierte Models → Entities
      return pokemons.map((model) => model.toEntity()).toList();
    } catch (e) {
      // Relanza el error para que el provider lo maneje
      rethrow;
    }
  }

  @override
  Future<Pokemon> getPokemonDetail(int id) async {
    try {
      final model = await _datasource.getPokemonDetail(id);
      return model.toEntity();
    } catch (e) {
      rethrow;
    }
  }
}