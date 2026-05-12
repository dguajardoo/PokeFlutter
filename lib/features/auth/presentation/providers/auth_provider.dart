import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

// 1️⃣ Esto es el equivalente a tu Hilt Module
// Le dice a Riverpod cómo crear el AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

// 2️⃣ Este es el "estado" de la pantalla de auth
// Equivalente a tu data class de UI State en Kotlin
class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final bool isAuthenticated;

  const AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.isAuthenticated = false
  });

  // Equivalente a copy() en Kotlin data class
  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isAuthenticated
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated
    );
  }
}

// 3️⃣ Este es el equivalente a tu ViewModel
// Extiende Notifier — maneja el estado y la lógica
class AuthNotifier extends Notifier<AuthState> {
  // build() es equivalente a init{} en ViewModel
  // Define el estado inicial
  @override
  AuthState build() {
    // Verifica si ya hay sesión activa al iniciar
    final isLoggedIn = ref.read(authRepositoryProvider).isLoggedIn;
    return AuthState(isAuthenticated: isLoggedIn);
  }

  // Equivalente a una función en tu ViewModel
  Future<void> signIn(String email, String password) async {
    // Actualiza estado a "cargando"
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await ref.read(authRepositoryProvider).signIn(email, password);

    if (result != null) {
      // Login exitoso
      state = state.copyWith(isLoading: false, isAuthenticated: true);
    } else {
      state = state.copyWith(isLoading: false, errorMessage: 'Email o contraseña incorrectos');
    }
  }

  Future<void> signUp(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await ref.read(authRepositoryProvider).signUp(email, password);

    if (result != null) {
      state = state.copyWith(isLoading: false, isAuthenticated: true);
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al crear la cuenta',
      );
    }
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = state.copyWith(isAuthenticated: false);
  }
}
// 4️⃣ Registra el Notifier como provider
// Equivalente a @HiltViewModel en Kotlin
final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
