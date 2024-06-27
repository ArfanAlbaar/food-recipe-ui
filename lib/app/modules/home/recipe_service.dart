import 'dart:convert';

import 'package:http/http.dart' as http;

class RecipeService {
  static const String baseUrl = "http://localhost:8080/api/recipe";

  // final StorageService _storage = StorageService();
  //LIST
  Future<List<dynamic>> getListRecipe() async {
    // final url = Uri.parse('$baseUrl?category=$category');
    final url = Uri.parse('$baseUrl');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  Future<Map<String, dynamic>> getRecipeById(int recipeId) async {
    final url = Uri.parse('$baseUrl/$recipeId');
    final response = await http.get(url);

    print(response.body);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load recipes');
    }
  }
}
