import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';

// Esta es la IMPLEMENTACIÓN — equivalente a tu RepositoryImpl en Kotlin
class AuthRepositoryImpl implements AuthRepository {
  // Instancia de Firebase Auth — equivalente a inyectar un datasource
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<String?> signIn(String email, String password) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      // Retorna el userId si fue exitoso
      return result.user?.uid;
    } catch (e) {
      // Retorna null si hubo error
      return null;
    }
  }

  @override
  Future<String?> signUp(String email, String password) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      // Retorna el userId si fue exitoso
      return result.user?.uid;
    } catch (e) {
      // Retorna null si hubo error
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  bool get isLoggedIn => _firebaseAuth.currentUser != null;
}