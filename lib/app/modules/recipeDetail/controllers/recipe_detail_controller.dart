import 'dart:convert';

import 'package:foodrecipeapp/app/models/resep.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RecipeDetailController extends GetxController {
  static final String baseUrl = "http://localhost:8080/api/recipe";

  var resep = Rxn<Resep>();

  Future<void> fetchRecipeById(int recipeId) async {
    final url = Uri.parse('$baseUrl/$recipeId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      resep.value = Resep.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load recipe');
    }
  }
}
