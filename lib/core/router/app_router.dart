import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../features/auth/presentation/screens/login_screen.dart';
import '../../../features/pokemon/presentation/screens/home_screen.dart';

// Rutas de la app como constantes
// Equivalente a tus destinos en Navigation Component
class AppRoutes {
  static const login = '/login';
  static const home = '/home';
}

// Provider del router — Riverpod lo maneja como dependencia
final routerProvider = Provider<GoRouter>((ref) {
  // Observa el estado de autenticación
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: AppRoutes.login,

    // redirect es equivalente a un NavController guard en Android
    // Se ejecuta antes de cada navegación
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final isOnLogin = state.matchedLocation == AppRoutes.login;

      // Si no está logueado y no está en login → manda al login
      if (!isLoggedIn && !isOnLogin) return AppRoutes.login;

      // Si está logueado y está en login → manda al home
      if (isLoggedIn && isOnLogin) return AppRoutes.home;

      // Sin redirección
      return null;
    },

    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
});
