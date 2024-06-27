import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../StorageService.dart';

class AdminService {
  static final String baseUrl = "http://localhost:8080/api";

  final StorageService _storage = StorageService();
  //LOGIN
  static Future<String> loginAdmin(String username, String password) async {
    final url = Uri.parse('$baseUrl/user/auth/login');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String token = jsonResponse['data']['token']; // Extract the token
      StorageService().writeToken(token); // Store token using StorageService
      return token;
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> logout() async {
    final url = Uri.parse('$baseUrl/user/auth/logout');
    final token = StorageService().readToken();

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'API-TOKEN': token!,
        },
      );

      if (response.statusCode == 200) {
        // Logout berhasil
        print('Logout berhasil');
      } else {
        // Handle error response
        print('Logout gagal dengan status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network error
      print('Error saat logout: $e');
    }
  }
}
