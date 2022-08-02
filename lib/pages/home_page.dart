import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokedex_kowok/controllers/pokedex_controller.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:pokedex_kowok/globals.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final controller = Get.put(PokedexController());

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
          appBar: AppBar(
              toolbarHeight: 60,
              actions: [
                Obx(
                  () => IconButton(
                      onPressed: () => controller.toggleSearch(),
                      icon: controller.isSearch.isTrue
                          ? const Icon(Icons.cancel_outlined)
                          : const Icon(Icons.search)),
                )
              ],
              leading: Obx(() => controller.isSearch.isTrue
                  ? const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 28,
                    )
                  : const Icon(
                      Icons.catching_pokemon,
                      color: Colors.white,
                      size: 28,
                    )),
              title: Obx(
                () => controller.isSearch.isTrue
                    ? Container(
                        padding: const EdgeInsets.only(top: 5),
                        child: TextField(
                          controller: controller.searchBar,
                          decoration: const InputDecoration(
                            hintText: 'Name or ID...',
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          onChanged: (val) {
                            controller.searchString.value = val;
                          },
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.only(top: 7),
                        child: const Text('POKEDEX')),
              )),
          body: LayoutBuilder(
            builder: ((context, constraints) {
              if (constraints.maxWidth <= 750) {
                return PokemonViewList();
              } else {
                return PokemonViewGrid();
              }
            }),
          ));
    });
  }
}

class PokemonViewList extends StatelessWidget {
  PokemonViewList({Key? key}) : super(key: key);

  final PokedexController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: controller.obx(
          onError: (error) => ErrorMessage(),
          (state) => LazyLoadScrollView(
            onEndOfPage: (() {
              if (state!.length == 1) return;
              if (!controller.status.isLoadingMore) {
                controller.getPokemonPagination(controller.nextPage);
              }
            }),
            child: ListView.builder(
                itemCount: state!.length + 1,
                itemBuilder: (context, i) {
                  if (i < state.length) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: backgroundFade, width: 1.0),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.elliptical(100, 100),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                      child: ListTile(
                        hoverColor: GetPlatform.isWeb
                            ? Colors.transparent
                            : backgroundFade,
                        onTap: () =>
                            controller.goToDetailPage(state[i].id.toString()),
                        leading: CircleAvatar(
                          child: Image.network(
                            state[i].defaultSprite,
                          ),
                        ),
                        title: Text(
                            "${state[i].id.toString().padLeft(3, '0')}: ${state[i].name.capitalize}"),
                        trailing: IconButton(
                          onPressed: () =>
                              controller.goToDetailPage(state[i].id.toString()),
                          icon: const Icon(
                            Icons.double_arrow,
                            color: backgroundFade,
                          ),
                        ),
                      ),
                    );
                  } else if (state.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Center(
                        child: Text(
                          'No Pokemon Found...',
                        ),
                      ),
                    );
                  } else {
                    return state.length > 1
                        ? const Padding(
                            padding: EdgeInsets.all(8),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : const SizedBox(
                            height: 0,
                          );
                  }
                }),
          ),
        ))
      ],
    );
  }
}

class PokemonViewGrid extends StatelessWidget {
  PokemonViewGrid({Key? key}) : super(key: key);

  final PokedexController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    const double itemHeight = 60;
    final double itemWidth = (Get.width / 2) - 100;
    return Center(
      child: Container(
          padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
          child: controller.obx(
              onError: (error) => ErrorMessage(),
              (state) => LazyLoadScrollView(
                  onEndOfPage: (() {
                    if (state!.length == 1) return;
                    if (!controller.status.isLoadingMore) {
                      controller.getPokemonPagination(controller.nextPage);
                    }
                  }),
                  child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: itemWidth / itemHeight,
                      children: [
                        for (int i = 0; i < state!.length + 1; i++)
                          if (i < state.length)
                            InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              onTap: () => controller
                                  .goToDetailPage(state[i].id.toString()),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: backgroundFade, width: 1.0),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.elliptical(100, 100),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(50),
                                    topRight: Radius.circular(50),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CircleAvatar(
                                      child: Image.network(
                                        state[i].defaultSprite,
                                      ),
                                    ),
                                    Text(
                                        "${state[i].id.toString().padLeft(3, '0')}: ${state[i].name.capitalize}"),
                                    IconButton(
                                      onPressed: () =>
                                          controller.goToDetailPage(
                                              state[i].id.toString()),
                                      icon: const Icon(
                                        Icons.double_arrow,
                                        color: backgroundFade,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else if (state.isEmpty)
                            const Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Center(
                                child: Text(
                                  'No Pokemon Found...',
                                ),
                              ),
                            )
                          else
                            state.length > 1
                                ? const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : const SizedBox(
                                    height: 0,
                                  ),
                      ])))),
    );
  }
}

class ErrorMessage extends StatelessWidget {
  ErrorMessage({Key? key}) : super(key: key);

  final PokedexController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 20,
        ),
        OutlineTitle(title: 'Oops something error...'),
        SizedBox(
          height: 30,
        ),
        ElevatedButton(
            onPressed: () => controller.getPokemonListHome(),
            child: Text('Retry...')),
      ],
    );
  }
}
