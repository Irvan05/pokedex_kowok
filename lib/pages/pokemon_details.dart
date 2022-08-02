import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokedex_kowok/controllers/pokedetails_controller.dart';
import 'package:pokedex_kowok/globals.dart';

class PokemonDetailsPage extends GetView<PokedetailsController> {
  PokemonDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return GetPlatform.isWeb && constraints.maxWidth > 600
          ? WebContainer()
          : PokeDetailsScaffold();
    });
  }
}

class WebContainer extends StatelessWidget {
  WebContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
        width: 500,
        height: Get.height - 100,
        decoration: BoxDecoration(
          color: deviceMainColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.9),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(3, 3),
            ),
          ],
        ),
        child: Container(
            decoration: BoxDecoration(
              color: darkModeBg,
            ),
            child: PokeDetailsScaffold()),
      ),
    );
  }
}

class PokeDetailsScaffold extends StatelessWidget {
  PokeDetailsScaffold({Key? key}) : super(key: key);

  final PokedetailsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: controller.obx(
            (state) => Text(
                '#${controller.pokeDetails.id.toString().padLeft(3, '0')}: ${controller.pokeDetails.name.toString().capitalize}'),
          ),
        ),
        body: controller.obx((state) => ScrollViewDetailPage()));
  }
}

class ScrollViewDetailPage extends StatelessWidget {
  const ScrollViewDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          PokemonTopCard(),
          SizedBox(
            height: 10,
          ),
          PokemonTypes(),
          SizedBox(
            height: 20,
          ),
          OutlineTitle(title: 'Base Stat'),
          SizedBox(
            height: 20,
          ),
          PokemonStatList(),
          SizedBox(
            height: 20,
          ),
          OutlineTitle(title: 'Evolution Chain'),
          SizedBox(
            height: 20,
          ),
          PokemonEvolutionChain(),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class PokemonTopCard extends StatelessWidget {
  PokemonTopCard({Key? key}) : super(key: key);

  final PokedetailsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: controller.pokeDetails.types.length == 1
          ? BoxDecoration(
              color: Color(colorTag[controller.pokeDetails.types.keys.first] ??
                  0xFF706f6b),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)))
          : BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(colorTag[controller.pokeDetails.types.keys.first] ??
                      0xFF706f6b),
                  Color(colorTag[controller.pokeDetails.types.keys.last] ??
                      0xFF706f6b)
                ],
              )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  width: GetPlatform.isWeb && Get.width > 600
                      ? 200
                      : Get.width * 0.4,
                  child: Image.network(
                    controller.pokeDetails.defaultSprite,
                    fit: BoxFit.contain,
                  )),
              Container(
                  padding: EdgeInsets.only(left: 8), child: PokemonSideInfo())
            ],
          ),
        ],
      ),
    );
  }
}

class PokemonSideInfo extends StatelessWidget {
  PokemonSideInfo({Key? key}) : super(key: key);

  final PokedetailsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        OutlineTitle(title: 'Abilities:'),
        SizedBox(
          height: 15,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          decoration: BoxDecoration(
              color: abilities,
              borderRadius: BorderRadius.all(Radius.circular(100.0))),
          child: Text('${controller.pokeDetails.abilities[0].name.capitalize}'),
        ),
        SizedBox(
          height: 10,
        ),
        controller.pokeDetails.abilities.length > 1
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                decoration: BoxDecoration(
                    color: abilities,
                    borderRadius: BorderRadius.all(Radius.circular(100.0))),
                child: Text(
                    '${controller.pokeDetails.abilities[1].name.capitalize}'),
              )
            : Container(),
      ],
    );
  }
}

class PokemonTypes extends StatelessWidget {
  PokemonTypes({Key? key}) : super(key: key);

  final PokedetailsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var key in controller.pokeDetails.types.keys)
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                  color: Color(colorTag[key] ?? 0xFF706f6b),
                  borderRadius: BorderRadius.all(Radius.circular(100.0))),
              width: controller.pokeDetails.types.length == 2
                  ? GetPlatform.isWeb
                      ? (490 * 0.5) - 20
                      : (Get.width * 0.5) - 20
                  : GetPlatform.isWeb
                      ? (490) - 20
                      : Get.width - 20,
              child: Center(
                  child: Stack(children: [
                Text(
                  '${key.capitalize}',
                  style: TextStyle(
                    fontSize: 20,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 2
                      ..color = background,
                  ),
                ),
                Text(
                  '${key.capitalize}',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ])),
            ),
          )
      ],
    );
  }
}

class PokemonStatList extends StatelessWidget {
  PokemonStatList({Key? key}) : super(key: key);

  final PokedetailsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          StatRow(
              name: 'HP',
              stat: controller.pokeDetails.baseStats!.hp,
              color: hp,
              bgColor: hpBg),
          SizedBox(
            height: 10,
          ),
          StatRow(
              name: 'ATK',
              stat: controller.pokeDetails.baseStats!.attack,
              color: atk,
              bgColor: atkBg),
          SizedBox(
            height: 10,
          ),
          StatRow(
              name: 'DEF',
              stat: controller.pokeDetails.baseStats!.defense,
              color: def,
              bgColor: defBg),
          SizedBox(
            height: 10,
          ),
          StatRow(
              name: 'S.ATK',
              stat: controller.pokeDetails.baseStats!.specialAttack,
              color: sAtk,
              bgColor: sAtkBg),
          SizedBox(
            height: 10,
          ),
          StatRow(
              name: 'S.DEF',
              stat: controller.pokeDetails.baseStats!.specialDefense,
              color: sDef,
              bgColor: sDefBg),
          SizedBox(
            height: 10,
          ),
          StatRow(
              name: 'SPD',
              stat: controller.pokeDetails.baseStats!.speed,
              color: spd,
              bgColor: spdBg),
        ],
      ),
    );
  }
}

class StatRow extends StatelessWidget {
  StatRow(
      {required this.name,
      required this.stat,
      required this.color,
      required this.bgColor,
      Key? key})
      : super(key: key);

  final String name;
  final String stat;
  final Color color;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            name,
            style: TextStyle(fontSize: 10),
          ),
        ),
        SizedBox(
          width: GetPlatform.isWeb ? 490 - 90 : Get.width - 80,
          child: Stack(children: [
            LinearProgressIndicator(
              value: double.parse(stat) / 150,
              color: color,
              backgroundColor: bgColor,
              minHeight: 20,
              semanticsLabel: 'test',
            ),
            Align(
              child: Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Stack(children: [
                  Text(
                    stat + ' / 300',
                    style: TextStyle(
                      fontSize: 18,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 1
                        ..color = Colors.black,
                    ),
                  ),
                  Text(
                    stat + ' / 300',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ]),
              ),
              alignment: Alignment.center,
            ),
          ]),
        ),
      ],
    );
  }
}

class PokemonEvolutionChain extends StatelessWidget {
  PokemonEvolutionChain({Key? key}) : super(key: key);

  final PokedetailsController controller = Get.find();
  static const widthCol = 150.0;

  @override
  Widget build(BuildContext context) {
    return controller.obx((state) => controller.status.isLoadingMore
        ? const Padding(
            padding: EdgeInsets.all(8),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : SizedBox(
            width: GetPlatform.isWeb ? 490 - 16 : Get.width - 16,
            height: controller.evoWidgetHeight.value,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 5),
                  width: widthCol,
                  child: Center(
                    child: Column(
                      children: [
                        Text('Basic'),
                        SizedBox(
                          height: 10,
                        ),
                        CircleAvatar(
                          backgroundColor: background,
                          radius: 50,
                          child: Image.network(
                            controller.pokeDetails.pokemonEvoChainEx
                                .currentEvoPokemon.defaultSprite,
                            fit: BoxFit.contain,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                controller.evo2Num > 0
                    ? Container(
                        padding: EdgeInsets.only(top: 5),
                        width: controller.evo3Num > 0 ? widthCol * 2 : widthCol,
                        child: controller.evo3Num > 0
                            ? Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        child: Center(child: Text('Middle')),
                                        width: widthCol,
                                      ),
                                      SizedBox(
                                        child: Center(child: Text('Final')),
                                        width: widthCol,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                    width: widthCol * 2,
                                  ),
                                  for (int i = 0;
                                      i <
                                          controller
                                              .pokeDetails
                                              .pokemonEvoChainEx
                                              .nextEvoChain
                                              .length;
                                      i++)
                                    for (int j = 0;
                                        j <
                                            controller
                                                .pokeDetails
                                                .pokemonEvoChainEx
                                                .nextEvoChain[i]
                                                .nextEvoChain
                                                .length;
                                        j++)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          j == 0
                                              ? Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 5),
                                                  width: widthCol,
                                                  child: Center(
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          background,
                                                      radius: 50,
                                                      child: Image.network(
                                                        controller
                                                            .pokeDetails
                                                            .pokemonEvoChainEx
                                                            .nextEvoChain[i]
                                                            .currentEvoPokemon
                                                            .defaultSprite,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 5),
                                                  width: widthCol,
                                                ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            width: widthCol,
                                            child: Center(
                                              child: CircleAvatar(
                                                backgroundColor: background,
                                                radius: 50,
                                                child: Image.network(
                                                  controller
                                                      .pokeDetails
                                                      .pokemonEvoChainEx
                                                      .nextEvoChain[i]
                                                      .nextEvoChain[j]
                                                      .currentEvoPokemon
                                                      .defaultSprite,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                ],
                              )
                            : Column(
                                children: [
                                  Text('Evo2'),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  for (var data in controller.pokeDetails
                                      .pokemonEvoChainEx.nextEvoChain)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: CircleAvatar(
                                        backgroundColor: background,
                                        radius: 50,
                                        child: Image.network(
                                          data.currentEvoPokemon.defaultSprite,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    )
                                ],
                              ),
                      )
                    : SizedBox(
                        width: 0,
                        height: 0,
                      ),
              ],
            ),
          ));
  }
}
