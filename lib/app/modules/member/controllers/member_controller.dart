import 'package:foodrecipeapp/app/routes/app_pages.dart';
import 'package:get/get.dart';

import '../StorageMemberService.dart';
import '../member_service.dart';

class MemberController extends GetxController {
  // Register
  Future<void> registerMember(
      String username, String name, String password, String phoneNumber) async {
    isLoading(true);
    final response = await MemberService.registerMember(
        username, name, password, phoneNumber);

    if (response != null) {
      Get.offAllNamed(Routes.LOGINMEMBER); //ARAHKAN KE PEMBAYARAN
    } else {
      Get.snackbar('Error', 'Register gagal');
    }
    isLoading(false);
  }

  var isLoading = false.obs;
  var isLoggedIn = false.obs;

  final StorageMemberService _storage = StorageMemberService();

  @override
  void onInit() {
    super.onInit();
    final token = _storage.readToken();
    isLoggedIn(token != null);
  }

  //LOGIN
  Future<void> loginMember(String username, String password) async {
    isLoading(true);
    final token = await MemberService.loginMember(username, password);

    if (token != null) {
      isLoggedIn(true);
      Get.offAllNamed(Routes.MEMBER); //ARAHKAN KE PREMIUM RECIPE
    } else {
      Get.snackbar('Error', 'Login gagal');
    }
    isLoading(false);
  } //END LOGIN

  final MemberService _memberService = MemberService();
  Future<void> logoutMember() async {
    isLoading(true);
    await _memberService.logoutMember();
    _storage.removeToken();
    isLoggedIn(false);
    isLoading(false);
    Get.offAllNamed(Routes.HOME);
  }

  final count = 0.obs;
  void increment() => count.value++;
}
