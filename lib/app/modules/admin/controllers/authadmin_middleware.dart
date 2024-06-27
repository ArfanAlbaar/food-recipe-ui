import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/admin_controller.dart';

class AuthAdminMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final AdminController adminController = Get.find<AdminController>();

    if (adminController.isLoggedIn.value) {
      return null;
    }
    return RouteSettings(
        name: '/home'); // Jika isLoggedIn true, lanjutkan ke route yang diminta
  }
}
