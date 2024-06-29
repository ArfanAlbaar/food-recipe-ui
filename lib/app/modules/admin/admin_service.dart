import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import '../../StorageService.dart';
import '../../models/premium_list.dart';
import '../../models/resep.dart';
import '../../models/transaction.dart';

class AdminService {
  static final String baseUrl = "http://localhost:8080/api";

  final StorageService _storage = StorageService();

  // LOGIN
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
      String token = jsonResponse['data']['token'];
      StorageService().writeToken(token);
      return token;
    } else {
      throw Exception('Failed to login');
    }
  }

  // LOGOUT
  Future<void> logout() async {
    final url = Uri.parse('$baseUrl/user/auth/logout');
    final token = _storage.readToken();

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'API-TOKEN': token!,
        },
      );

      if (response.statusCode == 200) {
        print('Logout berhasil');
      } else {
        print('Logout gagal dengan status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saat logout: $e');
    }
  }

  // EDIT FOOD
  Future<bool> editFood(int index, Resep newFood) async {
    final token = _storage.readToken();
    final url = Uri.parse('$baseUrl/recipe/$index');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'API-TOKEN': token!,
      },
      body: jsonEncode(newFood.toJson()),
    );

    if (response.statusCode == 202) {
      return true;
    } else {
      return false;
    }
  }

  // FETCH TRANSACTIONS
  Future<List<Transaction>> fetchTransactions() async {
    final token = _storage.readToken();
    if (token == null) throw Exception('No token found');

    final url = Uri.parse('$baseUrl/transaction/list');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'API-TOKEN': token!,
      },
    );

    if (response.statusCode == 200) {
      // List<dynamic> jsonResponse = json.decode(response.body);
      // return jsonResponse.map((data) => Transaction.fromJson(data)).toList();
      List<dynamic> body = json.decode(response.body);
      List<Transaction> transactions =
          body.map((dynamic item) => Transaction.fromJson(item)).toList();
      return transactions;
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  // DELETE TRANSACTION
  Future<bool> deleteTransaction(int id) async {
    final token = _storage.readToken();
    if (token == null) throw Exception('No token found');

    final url = Uri.parse('$baseUrl/transaction/$id');
    final response = await http.delete(
      url,
      headers: {
        'API-TOKEN': token!,
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // LIST PREMIUM
  Future<List<PremiumList>> getListPremium() async {
    final token = _storage.readToken();
    final url = Uri.parse('$baseUrl/premium/auth/admin/list');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'API-TOKEN': token!,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => PremiumList.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load premiums');
    }
  }

  // GET PREMIUM BY ID
  Future<PremiumList> getPremiumById(int id) async {
    final token = _storage.readToken();
    final url = Uri.parse('$baseUrl/premium/$id');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'API-TOKEN': token!,
      },
    );

    if (response.statusCode == 200) {
      return PremiumList.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load premium');
    }
  }

  Future<bool> editPremium(int id, String premiumName) async {
    final token = _storage.readToken();
    final url = Uri.parse('$baseUrl/premium/$id');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'API-TOKEN': token!,
      },
      body: jsonEncode({'premiumName': premiumName}),
    );

    return response.statusCode == 200;
  }

  Future<bool> addPremiumWithPdf(String premiumName, PlatformFile file) async {
    final token = _storage.readToken();
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/premium'))
      ..headers['API-TOKEN'] = token!
      ..fields['premiumName'] = premiumName
      ..files.add(await http.MultipartFile.fromPath('file', file.path!));

    final response = await request.send();
    final responseBody = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to add premium: ${responseBody.body}');
      return false;
    }
  }

  // DELETE PREMIUM
  Future<bool> deletePremium(int index) async {
    final token = _storage.readToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/premium/$index'),
      headers: {
        'API-TOKEN': token!,
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
