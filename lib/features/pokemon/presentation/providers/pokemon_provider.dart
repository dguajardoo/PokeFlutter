import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/pokemon_remote_datasource.dart';
import '../../data/repositories/pokemon_repository_impl.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../../domain/usecases/get_pokemon_list_usecase.dart';

// 1️⃣ Provider del datasource
final pokemonDatasourceProvider = Provider<PokemonRemoteDatasource>((ref) {
  return PokemonRemoteDatasource();
});

// 2️⃣ Provider del repositorio
final pokemonRepositoryProvider = Provider<PokemonRepository>((ref) {
  return PokemonRepositoryImpl(
    datasource: ref.watch(pokemonDatasourceProvider),
  );
});

// 3️⃣ Provider del usecase
final getPokemonListUseCaseProvider = Provider<GetPokemonListUseCase>((ref) {
  return GetPokemonListUseCase(
    repository: ref.watch(pokemonRepositoryProvider),
  );
});

// 4️⃣ Estado de la pantalla
class PokemonState {
  final List<Pokemon> pokemons;
  final bool isLoading;
  final bool isLoadingMore; // Para paginación
  final String? errorMessage;
  final int offset;         // Para saber desde dónde cargar más

  const PokemonState({
    this.pokemons = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.offset = 0,
  });

  PokemonState copyWith({
    List<Pokemon>? pokemons,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    int? offset,
  }) {
    return PokemonState(
      pokemons: pokemons ?? this.pokemons,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage ?? this.errorMessage,
      offset: offset ?? this.offset,
    );
  }
}

// 5️⃣ Notifier — el ViewModel
class PokemonNotifier extends Notifier<PokemonState> {
  @override
  PokemonState build() {
    // Carga los pokémon al iniciar
    Future.microtask(() => loadPokemons());
    return const PokemonState(isLoading: true);
  }

  Future<void> loadPokemons() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final useCase = ref.read(getPokemonListUseCaseProvider);
      final pokemons = await useCase(limit: 20, offset: 0);
      state = state.copyWith(
        pokemons: pokemons,
        isLoading: false,
        offset: 20,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al cargar los Pokémon',
      );
    }
  }

  // Carga más pokémon al llegar al final de la lista (paginación)
  Future<void> loadMore() async {
    // Evita cargar más si ya está cargando
    if (state.isLoadingMore || state.isLoading) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final useCase = ref.read(getPokemonListUseCaseProvider);
      final newPokemons = await useCase(
        limit: 20,
        offset: state.offset,
      );

      // Agrega los nuevos a los existentes
      state = state.copyWith(
        pokemons: [...state.pokemons, ...newPokemons],
        isLoadingMore: false,
        offset: state.offset + 20,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: 'Error al cargar más Pokémon',
      );
    }
  }
}

// 6️⃣ Registra el Notifier
final pokemonProvider = NotifierProvider<PokemonNotifier, PokemonState>(
  PokemonNotifier.new,
);