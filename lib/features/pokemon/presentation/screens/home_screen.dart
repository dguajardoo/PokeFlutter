import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/pokemon_provider.dart';
import '../widgets/pokemon_card.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // ScrollController para detectar cuando llegamos al final
  // Equivalente a un RecyclerView.OnScrollListener en Android
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Agrega listener al scroll
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Detecta si llegamos cerca del final de la lista
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final threshold = maxScroll * 0.9; // 90% del scroll

    if (currentScroll >= threshold) {
      // Carga más pokémon
      ref.read(pokemonProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final pokemonState = ref.watch(pokemonProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PokéDex',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authProvider.notifier).signOut(),
          ),
        ],
      ),
      body: _buildBody(pokemonState),
    );
  }

  Widget _buildBody(PokemonState state) {
    // Cargando por primera vez
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.red),
      );
    }

    // Error
    if (state.errorMessage != null && state.pokemons.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(state.errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(pokemonProvider.notifier).loadPokemons(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    // Lista de pokémon
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      // 2 columnas
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      // +1 para el loader al final si está cargando más
      itemCount: state.pokemons.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        // Último item — muestra loader de paginación
        if (index == state.pokemons.length) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.red),
          );
        }

        return PokemonCard(pokemon: state.pokemons[index]);
      },
    );
  }
}