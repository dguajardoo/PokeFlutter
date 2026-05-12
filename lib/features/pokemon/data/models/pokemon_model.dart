import '../../domain/entities/pokemon.dart';

// Model — equivalente a tu data class con @SerializedName en Kotlin
// Sabe cómo convertir JSON → objeto Dart
class PokemonModel {
  final int id;
  final String name;
  final List<String> types;

  const PokemonModel({
    required this.id,
    required this.name,
    required this.types,
  });

  // fromJson — equivalente a usar Gson/Moshi en Kotlin
  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    return PokemonModel(
      id: json['id'],
      name: json['name'],
      // Los tipos vienen anidados en el JSON de PokéAPI
      // json['types'] es una lista de objetos así:
      // [{ "type": { "name": "fire" } }, { "type": { "name": "flying" } }]
      types: (json['types'] as List)
          .map((t) => t['type']['name'] as String)
          .toList(),
    );
  }

  // Convierte Model → Entity (separa capas)
  // Equivalente a un mapper en Kotlin
  Pokemon toEntity() {
    return Pokemon(
      id: id,
      name: name,
      // La imagen de cada Pokémon siempre sigue este patrón de URL
      imageUrl:
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
      types: types,
    );
  }
}

// Este model es para la lista inicial que retorna PokéAPI
// La lista solo trae nombre y URL, no los detalles
class PokemonListItemModel {
  final String name;
  final String url;

  const PokemonListItemModel({
    required this.name,
    required this.url,
  });

  factory PokemonListItemModel.fromJson(Map<String, dynamic> json) {
    return PokemonListItemModel(
      name: json['name'],
      url: json['url'],
    );
  }

  // Extrae el ID desde la URL
  // La URL es así: https://pokeapi.co/api/v2/pokemon/25/
  int get id {
    final parts = url.split('/');
    return int.parse(parts[parts.length - 2]);
  }
}