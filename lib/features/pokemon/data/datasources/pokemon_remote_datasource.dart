import 'package:dio/dio.dart';
import '../models/pokemon_model.dart';

class PokemonRemoteDatasource {
  final Dio _dio;

  PokemonRemoteDatasource({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: 'https://pokeapi.co/api/v2/'));

  // Trae la lista inicial de pokémon (solo nombre y URL)
  // limit = cuántos traer, offset = desde cuál empezar (para paginación)
  Future<List<PokemonListItemModel>> getPokemonList({
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await _dio.get(
      'pokemon',
      queryParameters: {'limit': limit, 'offset': offset},
    );

    final results = response.data['results'] as List;
    return results
        .map((item) => PokemonListItemModel.fromJson(item))
        .toList();
  }

  // Trae el detalle de un pokémon por su ID
  Future<PokemonModel> getPokemonDetail(int id) async {
    final response = await _dio.get('pokemon/$id');
    return PokemonModel.fromJson(response.data);
  }
}