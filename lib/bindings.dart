import 'package:get/get.dart';
import 'package:pokedex_kowok/controllers/pokedetails_controller.dart';

class PokedetailsBinding implements Bindings {
  String id;
  PokedetailsBinding({required this.id});

  @override
  void dependencies() {
    Get.put(PokedetailsController(id: id));
  }
}
