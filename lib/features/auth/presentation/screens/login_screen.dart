import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

// ConsumerWidget es equivalente a un @Composable que observa un ViewModel
// Es como StatelessWidget pero con acceso a Riverpod

// ConsumerStatefulWidget = StatefulWidget + acceso a Riverpod
// Equivalente a un @Composable que usa remember() + ViewModel
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // Ahora los controllers viven en el State — se crean una sola vez
  // Equivalente a remember { mutableStateOf("") } en Compose
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Limpia los controllers cuando el widget se destruye
  // Equivalente a onCleared() en ViewModel
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  // "ref" es equivalente a usar viewModel en un Composable
  Widget build(BuildContext context) {
    // Observa el estado — equivalente a collectAsState() en Compose
    final authState = ref.watch(authProvider);

    // Controladores de texto — equivalente a mutableStateOf("") en Compose
    //final emailController = TextEditingController();
    //final passwordController = TextEditingController();

    if (authState.isAuthenticated) {
      return const Scaffold(
        body: Center(
          child: Text('¡Bienvenido! ✅'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.network(
                  'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png',
                  height: 100,
                ),
                const SizedBox(height: 16),

                // Título
                const Text(
                  'PokéDex',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),

                const SizedBox(height: 48),

                // Campo Email
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Campo Password
                TextField(
                  controller: _passwordController,
                  obscureText: true, // Oculta el texto como un password
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Mensaje de error
                if (authState.errorMessage != null)
                  Text(
                    authState.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),

                const SizedBox(height: 24),

                // Botón Login
                SizedBox(
                  width: double.infinity, // Ancho completo
                  height: 50,
                  child: ElevatedButton(
                    onPressed: authState.isLoading
                        ? null // Desactiva el botón mientras carga
                        : () => ref.read(authProvider.notifier).signIn(
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: authState.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Iniciar Sesión',
                        style: TextStyle(fontSize: 16)),
                  ),
                ),

                const SizedBox(height: 16),

                // Botón Registro
                TextButton(
                  onPressed: authState.isLoading
                      ? null
                      : () => ref.read(authProvider.notifier).signUp(
                    _emailController.text.trim(),
                    _passwordController.text.trim(),
                  ),
                  child: const Text(
                    '¿No tienes cuenta? Regístrate',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          )
      ),
    );

  }
}