import '../entities/pokemon.dart';
import '../repositories/pokemon_repository.dart';

// UseCase — igual que en Android, encapsula una operación de negocio
// Equivalente a tu UseCase en Kotlin
class GetPokemonListUseCase {
  final PokemonRepository _repository;

  GetPokemonListUseCase({required PokemonRepository repository})
      : _repository = repository;

  // En Dart se puede hacer la clase "callable"
  // Es como definir un operador invoke() en Kotlin
  Future<List<Pokemon>> call({
    int limit = 20,
    int offset = 0,
  }) async {
    return _repository.getPokemonList(
      limit: limit,
      offset: offset,
    );
  }
}