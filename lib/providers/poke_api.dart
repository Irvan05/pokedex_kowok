import 'package:get/get.dart';

class PokeApiProvider extends GetConnect {
  final url = 'https://pokeapi.co/api/v2/';

  Future<Response> getPokemonList() => get('${url}pokemon?limit=24&offset=0');
  Future<Response> getPokemonAutoUrl(String customUrl) {
    return get(customUrl);
  }

  Future<Response> getPokemonDetails(String nameOrId) {
    return get('${url}pokemon/$nameOrId');
  }

  Future<Response> getPokemonSpecies(String id) =>
      get('${url}pokemon-species/$id/');
}
