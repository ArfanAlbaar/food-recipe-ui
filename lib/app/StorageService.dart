import 'package:get_storage/get_storage.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;

  StorageService._internal();

  final GetStorage _box = GetStorage();

  void writeToken(String token) {
    _box.write('auth_token', token);
  }

  String? readToken() {
    return _box.read('auth_token');
  }

  void removeToken() {
    _box.remove('auth_token');
  }
}
