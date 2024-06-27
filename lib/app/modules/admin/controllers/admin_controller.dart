import 'dart:convert';

import 'package:foodrecipeapp/app/StorageService.dart';
import 'package:foodrecipeapp/app/models/premium_list.dart';
import 'package:foodrecipeapp/app/models/resep.dart';
import 'package:foodrecipeapp/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../home/recipe_service.dart';
import '../admin_service.dart';
import '../views/resep/managementResep_view.dart';

class AdminController extends GetxController {
  var recipes = <Resep>[].obs; // Observable list of Resep
  var premiums = <PremiumList>[].obs;

  RxBool isFavorite = false.obs;
  var isLoading = false.obs;
  var isLoggedIn = false.obs;

  final StorageService _storage = StorageService();
  final RecipeService recipeService = RecipeService();

  @override
  void onInit() {
    super.onInit();
    final token = _storage.readToken();
    isLoggedIn(token != null);
    // fetchAllRecipes();
    // fetchAllPremiums();
  }

  final AdminService _adminService = AdminService();

  Future<void> loginAdmin(String username, String password) async {
    isLoading(true);
    final token = await AdminService.loginAdmin(username, password);
    if (token != null) {
      _storage.writeToken(token);
      isLoggedIn(true);
      Get.offAllNamed(Routes.ADMIN);
    } else {
      Get.snackbar('Error', 'Login gagal');
    }
    isLoading(false);
  }

  Future<void> logoutAdmin() async {
    isLoading(true);
    await _adminService.logout();
    _storage.removeToken();
    isLoggedIn(false);
    isLoading(false);
    Get.offAllNamed(Routes.HOME);
  }

  void fetchAllRecipes() async {
    try {
      isLoading(true);
      List<dynamic> result = await recipeService.getListRecipe();
      recipes.assignAll(result.map((item) => Resep.fromJson(item)));
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch recipes');
    } finally {
      isLoading(false);
    }
  }

  void addFood(Resep food) async {
    final token = StorageService().readToken();
    final response = await http.post(
      Uri.parse('http://localhost:8080/api/recipe'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'API-TOKEN': token!,
      },
      body: jsonEncode(food.toJson()),
    );

    if (response.statusCode == 200) {
      recipes.add(food);
      Get.snackbar('Success', 'Food added successfully',
          snackPosition: SnackPosition.BOTTOM);
      Get.to(() => ManagementResep());
    } else {
      print('Failed to add food: ${response.body}');
      Get.snackbar('Error', 'Failed to add food',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> editFood(int index, Resep newFood) async {
    isLoading(true);
    final token = StorageService().readToken();
    final response = await _adminService.editFood(index, newFood);
    // print(response.body);
    if (response) {
      // foods[index] = newFood;
      Get.snackbar('Success', 'Food updated successfully',
          snackPosition: SnackPosition.BOTTOM);
      Get.to(() => ManagementResep());
    } else {
      Get.snackbar('Error', 'Failed to update food',
          snackPosition: SnackPosition.BOTTOM);
    }
    isLoading(false);
  }

  void deleteFood(int index) async {
    final token = StorageService().readToken();
    final response = await http.delete(
      Uri.parse('http://localhost:8080/api/recipe/${index}'),
      headers: {
        'API-TOKEN': token!,
      },
    );
    if (response.statusCode == 200) {
      Get.snackbar('Success', 'Recipe deleted successfully',
          snackPosition: SnackPosition.BOTTOM);
      fetchAllRecipes();
    } else {
      Get.snackbar('Error', 'Failed to delete recipe',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
  // * AKHIR BAGIAN API RESEP

  void fetchAllPremiums() async {
    try {
      isLoading(true);
      List<dynamic> result = await _adminService.getListPremium();
      premiums.assignAll(result.map((item) => PremiumList.fromJson(item)));
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch recipes');
    } finally {
      isLoading(false);
    }
  }

  void deletePremium(int index) async {
    final response = await _adminService.deletePremium(index);
    if (response) {
      Get.snackbar('Success', 'Premium recipe deleted successfully',
          snackPosition: SnackPosition.BOTTOM);
      fetchAllPremiums();
    } else {
      Get.snackbar('Error', 'Failed to delete premium recipe',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
