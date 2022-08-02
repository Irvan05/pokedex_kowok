import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pokedex_kowok/bindings.dart';
import 'package:pokedex_kowok/models/pokemon_details.dart';
import 'package:pokedex_kowok/pages/pokemon_details.dart';
import 'package:pokedex_kowok/providers/poke_api.dart';

class PokedexController extends GetxController
    with StateMixin<List<PokemonSimple>> {
  var pokemonList = List<PokemonSimple>.empty().obs;
  var pokemonSearchList = List<PokemonSimple>.empty().obs;

  late TextEditingController searchBar;
  var searchString = ''.obs;
  var isSearch = false.obs;

  late String? nextPage;
  late String? prevPage;

  @override
  void onInit() {
    super.onInit();
    initPage();

    searchBar = TextEditingController();
    debounce(searchString, (input) {
      if (status.isSuccess && input.toString().isNotEmpty) {
        searchPokemon(input.toString().toLowerCase());
      }
    }, time: const Duration(milliseconds: 1300));
  }

  @override
  void dispose() {
    super.dispose();
    searchBar.dispose();
  }

  void initPage() {
    getPokemonListHome();
  }

  void toggleSearch() {
    isSearch.toggle();
    if (isSearch.isFalse) {
      change(pokemonList, status: RxStatus.success());
    }
  }

  void searchPokemon(String input) async {
    change(null, status: RxStatus.loading());
    await PokeApiProvider().getPokemonDetails(input).then((response) async {
      if (pokemonSearchList.isNotEmpty) pokemonSearchList.removeAt(0);
      try {
        final rawData = response.body as Map<String, dynamic>;
        pokemonSearchList.add(PokemonSimple(
          name: rawData['name'],
          id: rawData['id'],
          defaultSprite: rawData['sprites']['front_default'],
        ));
      } catch (e) {
        print('search error: ');
        print(e.toString());
      }
    });
    change(pokemonSearchList, status: RxStatus.success());
  }

  void goToDetailPage(String id) {
    Get.to(() => PokemonDetailsPage(),
        binding: PokedetailsBinding(id: id.toString()), opaque: false);
  }

  void getPokemonListHome() async {
    change(null, status: RxStatus.loading());
    if (pokemonList.isNotEmpty) pokemonList.clear();
    await PokeApiProvider().getPokemonList().then((response) async {
      if (await pupulateHomePage(response)) {
        change(pokemonList, status: RxStatus.success());
      } else {
        change(pokemonList, status: RxStatus.error());
      }
    });
  }

  void getPokemonPagination(url) async {
    await PokeApiProvider().getPokemonAutoUrl(url).then((response) async {
      change(pokemonList, status: RxStatus.loadingMore());
      if (await pupulateHomePage(response)) {
        change(pokemonList, status: RxStatus.success());
      } else {
        change(pokemonList, status: RxStatus.error());
      }
    });
  }

  Future<bool> pupulateHomePage(var response) async {
    final rawData = response.body as Map<String, dynamic>;
    List<dynamic> data = rawData['results'];
    nextPage = rawData['next'];
    prevPage = rawData['previous'];

    try {
      for (int i = 0; i < data.length; i++) {
        await PokeApiProvider()
            .getPokemonAutoUrl(data[i]['url'])
            .then((response2) {
          final rawData2 = response2.body as Map<String, dynamic>;
          pokemonList.add(PokemonSimple(
              name: rawData2['name'],
              id: rawData2['id'],
              defaultSprite: rawData2['sprites']['front_default']));
        });
      }
    } catch (e) {
      print('failed populate homepage');
      print(e.toString());
      return false;
    }

    return true;
  }
}
