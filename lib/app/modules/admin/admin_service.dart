import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart'; // Import path for basename method

import '../../StorageService.dart';
import '../../models/listMember.dart';
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
    final url = Uri.parse('$baseUrl/premium/auth/admin/$id');
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
    if (response.statusCode == 202) {
      return true;
    } else {
      return false;
    }
  }

//CREATE PREMIUM
  Future<bool> uploadFile(PlatformFile file) async {
    final token = _storage.readToken();

    // Determine the MIME type
    String? mimeType = lookupMimeType(file.name);
    if (mimeType == null) {
      mimeType =
          'application/octet-stream'; // Default to binary stream if MIME type is unknown
    }

    // Create a MultipartFile from the file bytes
    var multipartFile = http.MultipartFile.fromBytes(
      'file',
      file.bytes!,
      filename: basename(file.name),
      contentType: MediaType.parse(mimeType),
    );

    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/premium'))
      ..files.add(multipartFile)
      ..headers.addAll({
        'Content-Type': 'multipart/form-data',
        'API-TOKEN': token!,
      });

    var response = await request.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to upload file, status code: ${response.statusCode}');
      throw Exception('Failed to upload file');
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

  // Member List
  Future<List<ListMember>> getListMembers() async {
    final token = _storage.readToken();
    final url = Uri.parse('$baseUrl/member/list');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'API-TOKEN': token!,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => ListMember.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load members');
    }
  }

  // Update Member
  Future<bool> updateMember(ListMember member) async {
    final token = _storage.readToken();
    final url = Uri.parse('$baseUrl/member/${member.username}');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'API-TOKEN': token!,
      },
      body: jsonEncode(member.toJson()),
    );

    return response.statusCode == 200;
  }

  // Delete Member
  Future<bool> deleteMember(String username) async {
    final token = _storage.readToken();
    final url = Uri.parse('$baseUrl/member/$username');
    final response = await http.delete(
      url,
      headers: {
        'API-TOKEN': token!,
      },
    );

    return response.statusCode == 200;
  }
}
