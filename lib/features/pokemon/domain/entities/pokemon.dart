// Entity — objeto puro de dominio, sin JSON ni Firebase
// Equivalente a tu data class en Kotlin
class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;

  const Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
  });
}