import 'dart:convert';
import 'package:foodrecipeapp/app/models/resep.dart';
import 'package:foodrecipeapp/app/modules/admin/views/resep/managementFood_view.dart';
import 'package:foodrecipeapp/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../admin_service.dart';
import 'package:foodrecipeapp/app/StorageService.dart';

class AdminController extends GetxController {
  var foods = <Resep>[].obs; // Observable list of Resep

  RxBool isFavorite = false.obs;
  var isLoading = false.obs;
  var isLoggedIn = false.obs;

  final StorageService _storage = StorageService();

  @override
  void onInit() {
    super.onInit();
    final token = _storage.readToken();
    isLoggedIn(token != null);
    fetchFoods();
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

  // * BAGIAN API RESEP
  void fetchFoods() async {
    final token = _storage.readToken();
    final response = await http.get(
      Uri.parse('http://localhost:8080/api/recipe'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      foods.value = jsonResponse.map((data) => Resep.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load foods');
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
      foods.add(food);
      Get.snackbar('Success', 'Food added successfully',
          snackPosition: SnackPosition.BOTTOM);
      Get.to(() => ManagementFood());
    } else {
      print('Failed to add food: ${response.body}');
      Get.snackbar('Error', 'Failed to add food',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void editFood(int index, Resep newFood) async {
    final token = StorageService().readToken();
    final response = await http.put(
      Uri.parse('http://localhost:8080/api/recipe/${index}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'API-TOKEN': token!,
      },
      body: jsonEncode(newFood.toJson()),
    );
    print(response.body);
    if (response.statusCode == 202) {
      foods[index] = newFood;
      Get.snackbar('Success', 'Food updated successfully',
          snackPosition: SnackPosition.BOTTOM);
      Get.to(() => ManagementFood());
    } else {
      Get.snackbar('Error', 'Failed to update food',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void deleteFood(int index) async {
    final token = StorageService().readToken();
    final food = foods[index];
    final response = await http.delete(
      Uri.parse('http://localhost:8080/api/recipe/${food.id}'),
      headers: {
        'API-TOKEN': token!,
      },
    );

    if (response.statusCode == 200) {
      foods.removeAt(index);
      Get.snackbar('Success', 'Food deleted successfully',
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('Error', 'Failed to delete food',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
  // * AKHIR BAGIAN API RESEP
}
