import 'package:foodrecipeapp/app/models/premium_list.dart';
import 'package:foodrecipeapp/app/routes/app_pages.dart';
import 'package:get/get.dart';

import '../StorageMemberService.dart';
import '../member_service.dart';

class MemberController extends GetxController {
  var premiums = <PremiumList>[].obs;
  // Register
  Future<void> registerMember(
      String username, String name, String password, String phoneNumber) async {
    isLoading(true);
    final response = await MemberService.registerMember(
        username, name, password, phoneNumber);

    if (response) {
      isLoading(false);
    } else {
      Get.snackbar('Error', 'Register gagal');
    }
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
    if (username.isEmpty) {
      Get.snackbar('Error', 'Username tidak boleh kosong');
      return;
    }
    if (password.isEmpty) {
      Get.snackbar('Error', 'Password tidak boleh kosong');
      return;
    }
    isLoading(true);

    try {
      final token = await MemberService.loginMember(username, password);
      if (token != null) {
        _storage.writeToken(token);
        isLoggedIn(true);
        Get.offNamed(Routes.MEMBER);
        Get.snackbar('Success', 'Login berhasil');
        //ARAHKAN KE PREMIUM RECIPE
      } else {
        Get.snackbar('Error', 'Username atau Password salah');
      }
    } catch (e) {
      Get.snackbar('Error', 'Username atau Password salah');
    } finally {
      isLoading(false);
    }
  } //END LOGIN

  final MemberService _memberService = MemberService();
  Future<void> logoutMember() async {
    isLoading(true);
    await _memberService.logoutMember();
    _storage.removeToken();
    isLoggedIn(false);
    isLoading(false);
    Get.offAllNamed(Routes.HOME);
    Get.snackbar("Success", "Logout Berhasil");
  }

  void fetchAllPremiums() async {
    try {
      isLoading(true);
      List<PremiumList> result = await _memberService.getListPremium();
      print(result);
      premiums.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch premiums');
    } finally {
      isLoading(false);
    }
  }

  final count = 0.obs;
  void increment() => count.value++;
}
