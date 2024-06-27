import 'package:get_storage/get_storage.dart';

class StorageMemberService {
  static final StorageMemberService _instance =
      StorageMemberService._internal();
  factory StorageMemberService() => _instance;

  StorageMemberService._internal();

  final GetStorage _box = GetStorage();

  void writeToken(String token) {
    _box.write('auth_x_token', token);
  }

  String? readToken() {
    return _box.read('auth_x_token');
  }

  void removeToken() {
    _box.remove('auth_x_token');
  }
}
