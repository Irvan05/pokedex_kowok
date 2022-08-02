import 'package:get/get.dart';
import 'package:pokedex_kowok/models/abilities.dart';
import 'package:pokedex_kowok/models/base_stats.dart';
import 'package:pokedex_kowok/models/evo_chain.dart';
import 'package:pokedex_kowok/models/pokemon_details.dart';

import '../providers/poke_api.dart';

class PokedetailsController extends GetxController with StateMixin<String> {
  late PokemonDetails pokeDetails;
  final id;

  var evoWidgetHeight = 140.0.obs;
  var evo2Num = 0.obs;
  var evo3Num = 0.obs;
  var evoWidgetCount = 1.0.obs;

  PokedetailsController({required this.id});

  @override
  void onInit() {
    change('init', status: RxStatus.loading());
    super.onInit();
    getPokemonDetails();
  }

  void searchPokemon(String input) {}

  void getPokemonDetails() async {
    await PokeApiProvider().getPokemonDetails(id).then((response) async {
      final rawData = response.body as Map<String, dynamic>;
      pokeDetails = PokemonDetails(
          name: rawData['name'],
          id: int.parse(id),
          defaultSprite: rawData['sprites']['front_default'],
          weight: double.parse(rawData['weight'].toString()) / 10,
          height: double.parse(rawData['height'].toString()) / 10,
          baseStats: PokemonBaseStats(
              hp: rawData['stats'][0]['base_stat'].toString(),
              attack: rawData['stats'][1]['base_stat'].toString(),
              defense: rawData['stats'][2]['base_stat'].toString(),
              specialAttack: rawData['stats'][3]['base_stat'].toString(),
              specialDefense: rawData['stats'][4]['base_stat'].toString(),
              speed: rawData['stats'][5]['base_stat'].toString()));

      final List<dynamic> abilities = rawData['abilities'];
      for (var data in abilities) {
        pokeDetails.abilities.add(PokemonAbilitiy(
            name: data['ability']['name'],
            url: data['ability']['url'],
            is_hidden: data['is_hidden']));
      }

      final List<dynamic> types = rawData['types'];
      for (var data in types) {
        pokeDetails.types[data['type']['name']] = data['type']['url'];
      }

      change('init', status: RxStatus.loadingMore());
      getPokemonEvoChainEx();
    });
  }

  Future<void> getPokemonEvoChainEx() async {
    try {
      var speciesResponse = await PokeApiProvider().getPokemonSpecies(id);
      final speciesBody = speciesResponse.body as Map<String, dynamic>;
      String evoChainUrl = speciesBody['evolution_chain']['url'];

      var evoChainResponse =
          await PokeApiProvider().getPokemonAutoUrl(evoChainUrl);
      final evoChainBody = evoChainResponse.body as Map<String, dynamic>;
      String evo1Url = evoChainBody['chain']['species']['url'].toString();
      String evo1Id = evo1Url.substring(42, evo1Url.length - 1);

      await getEvoMiddle(evoChainBody['chain']['evolves_to'], evo1Id);
    } catch (e) {
      print('getPokemonEvoChainEx');
      print(e.toString());
    }

    if (evo2Num.value >= 1) {
      evoWidgetHeight.value = evo2Num.value * 140.0;
      evoWidgetCount.value = 2;
      if (evo3Num.value >= 1) {
        evoWidgetCount.value = 3;
        if (evo3Num.value > evo2Num.value) {
          evoWidgetHeight.value = evo3Num.value * 140.0;
        }
      }
    }

    change('init', status: RxStatus.success());
  }

  Future<void> getEvoMiddle(evoChainBody, evo1Id) async {
    final evo1Response = await PokeApiProvider().getPokemonDetails(evo1Id);
    final evo1Body = evo1Response.body as Map<String, dynamic>;

    pokeDetails.pokemonEvoChainEx = PokemonEvoChainEx(
        currentEvoId: evo1Id,
        currentEvoPokemon: PokemonSimple(
          name: evo1Body['name'],
          id: evo1Body['id'],
          defaultSprite: evo1Body['sprites']['front_default'],
        ));

    final evo2List = evoChainBody as List<dynamic>;
    for (int i = 0; i < evo2List.length; i++) {
      evo2Num.value++;
      String evoUrl = evo2List[i]['species']['url'].toString();
      String evoId = evoUrl.substring(42, evoUrl.length - 1);
      final evoPokemonResponse =
          await PokeApiProvider().getPokemonDetails(evoId);
      final evoPokemonBody = evoPokemonResponse.body as Map<String, dynamic>;

      pokeDetails.pokemonEvoChainEx.nextEvoChain.add(PokemonEvoChainEx(
          currentEvoId: evoId,
          currentEvoPokemon: PokemonSimple(
            name: evoPokemonBody['name'],
            id: evoPokemonBody['id'],
            defaultSprite: evoPokemonBody['sprites']['front_default'],
          )));

      final evoChainNext = evo2List[i]['evolves_to'] as List<dynamic>;
      if (evoChainNext.isNotEmpty) {
        await getEvoFinal(evoChainNext, i);
      }
    }
  }

  Future<void> getEvoFinal(evoChainBody, int midEvoId) async {
    final evo2List = evoChainBody as List<dynamic>;
    for (var data in evo2List) {
      evo3Num.value++;
      String evoUrl = data['species']['url'].toString();
      String evoId = evoUrl.substring(42, evoUrl.length - 1);
      final evoPokemonResponse =
          await PokeApiProvider().getPokemonDetails(evoId);
      final evoPokemonBody = evoPokemonResponse.body as Map<String, dynamic>;

      pokeDetails.pokemonEvoChainEx.nextEvoChain[midEvoId].nextEvoChain
          .add(PokemonEvoChainEx(
              currentEvoId: evoId,
              currentEvoPokemon: PokemonSimple(
                name: evoPokemonBody['name'],
                id: evoPokemonBody['id'],
                defaultSprite: evoPokemonBody['sprites']['front_default'],
              )));
    }
  }
}
