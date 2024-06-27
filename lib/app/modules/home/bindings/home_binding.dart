import 'package:foodrecipeapp/app/modules/home/controllers/recipe_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecipeController>(
      () => RecipeController(),
    );
  }
}
