import 'dart:convert';

import 'package:foodrecipeapp/app/models/premium_list.dart';
import 'package:http/http.dart' as http;

import 'StorageMemberService.dart';

class MemberService {
  static final String baseUrl = "http://localhost:8080/api";
  bool _isDownloading = false;
  String _status = '';

  //REGISTER
  static Future<bool> registerMember(
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
      return true;
    } else {
      throw Exception('Failed to register');
      return false;
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

  static Future<dynamic> listdwonloadbymember() async {
    final url = Uri.parse('$baseUrl/premium/auth/member/list');
    final token = StorageMemberService().readToken();
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'X-API-TOKEN': token!,
      },
    );

    if (response.statusCode == 200) {
      String jsonResponse = jsonDecode(response.body);
      return true;
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<List<PremiumList>> getListPremium() async {
    final token = _storage.readToken();
    final url = Uri.parse('$baseUrl/premium/auth/member/list');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-API-TOKEN': token!,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => PremiumList.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load premiums');
    }
  }

  Future<http.Response> downloadPremiumByMember(int premiumId) async {
    final token = _storage.readToken();
    final url = Uri.parse('$baseUrl/premium/auth/member/$premiumId/download');
    final response = await http.get(
      url,
      headers: <String, String>{
        'X-API-TOKEN': token!,
      },
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to download file');
    }
  }
}
