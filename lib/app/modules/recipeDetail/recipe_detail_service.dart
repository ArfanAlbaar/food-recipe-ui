import 'dart:convert';

import 'package:http/http.dart' as http;

class RecipeDetailService {
  static final String baseUrl = "http://localhost:8080/api/recipe";

  Future<Map<String, dynamic>> getRecipe(int recipeId) async {
    final url = Uri.parse('$baseUrl/$recipeId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load recipe');
    }
  }
}
