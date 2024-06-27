import 'package:get/get.dart';

import '../recipe_service.dart';

class RecipeController extends GetxController {
  var recipes = <dynamic>[].obs;
  var isLoading = true.obs;
  final RecipeService recipeService = RecipeService();

  @override
  void onInit() {
    super.onInit();
    fetchAllRecipes();
  }

  void fetchAllRecipes() async {
    try {
      isLoading(true);
      var result = await recipeService.getListRecipe();
      recipes.assignAll(result);
    } finally {
      isLoading(false);
    }
  }

  List<dynamic> getRecipesByCategory(String category) {
    return recipes.where((recipe) => recipe['category'] == category).toList();
  }
}
