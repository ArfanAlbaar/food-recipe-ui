import 'dart:convert';

import 'package:http/http.dart' as http;

import 'StorageMemberService.dart';

class MemberService {
  static final String baseUrl = "http://localhost:8080/api";

  //REGISTER
  static Future<String> registerMember(
      String username, String name, String password, String phoneNumber) async {
    final url = Uri.parse('$baseUrl/member');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'name': name,
        'phoneNumber': phoneNumber,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      String jsonResponse = jsonDecode(response.body);
      return response.body;
    } else {
      throw Exception('Failed to register');
    }
  }

  final StorageMemberService _storage = StorageMemberService();
  //LOGIN
  static Future<String> loginMember(String username, String password) async {
    final url = Uri.parse('$baseUrl/member/auth/login');
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
      StorageMemberService()
          .writeToken(token); // Store token using StorageMemberService
      return token;
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> logoutMember() async {
    final url = Uri.parse('$baseUrl/member/auth/logout');
    final token = StorageMemberService().readToken();

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'X-API-TOKEN': token!,
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
