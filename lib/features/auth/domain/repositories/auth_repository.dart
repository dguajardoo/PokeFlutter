// Esta es la INTERFAZ — equivalente a tu interface en Kotlin
abstract class AuthRepository {
  // Retorna null si hay error, o el userId si fue exitoso
  Future<String?> signIn(String email, String password);
  Future<String?> signUp(String email, String password);
  Future<void> signOut();

  // Retorna true si hay un usuario logueado
  bool get isLoggedIn;

}