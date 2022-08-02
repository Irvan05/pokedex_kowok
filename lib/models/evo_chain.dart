import 'package:get/get.dart';
import 'package:pokedex_kowok/models/pokemon_details.dart';

class PokemonEvoChainEx {
  String currentEvoId;

  PokemonSimple currentEvoPokemon;

  List<PokemonEvoChainEx> nextEvoChain = List<PokemonEvoChainEx>.empty().obs;

  PokemonEvoChainEx({
    required this.currentEvoId,
    required this.currentEvoPokemon,
  });
}
