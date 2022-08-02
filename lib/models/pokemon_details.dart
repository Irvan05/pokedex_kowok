import 'package:get/get.dart';
import 'package:pokedex_kowok/models/abilities.dart';
import 'package:pokedex_kowok/models/base_stats.dart';
import 'package:pokedex_kowok/models/evo_chain.dart';

class PokemonDetails {
  String name;
  int id;
  String defaultSprite;

  double? weight;
  double? height;
  List<PokemonAbilitiy> abilities = List<PokemonAbilitiy>.empty().obs;
  Map<String, String> types = {};

  PokemonBaseStats? baseStats;

  late PokemonEvoChainEx pokemonEvoChainEx;

  PokemonDetails({
    required this.name,
    required this.id,
    required this.defaultSprite,
    this.weight,
    this.height,
    this.baseStats,
  });
}

class PokemonSimple {
  String name;
  int id;
  String defaultSprite;

  PokemonSimple({
    required this.name,
    required this.id,
    required this.defaultSprite,
  });
}
