import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'member_controller.dart';

class AuthMemberMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final MemberController memberController = Get.find<MemberController>();

    if (memberController.isLoggedIn.value) {
      return null;
    }
    return RouteSettings(
        name: '/home'); // Jika isLoggedIn true, lanjutkan ke route yang diminta
  }
}
