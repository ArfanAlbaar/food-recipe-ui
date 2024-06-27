import 'package:flutter/material.dart';
import 'package:foodrecipeapp/app/modules/admin/controllers/admin_controller.dart';
import 'package:foodrecipeapp/app/modules/home/controllers/recipe_controller.dart';
import 'package:foodrecipeapp/app/modules/member/controllers/member_controller.dart';
import 'package:foodrecipeapp/app/widgets/colors.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../../routes/app_pages.dart';

class ChooseLogin extends GetView<RecipeController> {
  const ChooseLogin({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<AdminController>(
      () => AdminController(),
    );
    final AdminController adminController = Get.find();
    Get.lazyPut<MemberController>(
      () => MemberController(),
    );
    final MemberController memberController = Get.find();

    // Check if already logged in
    if (adminController.isLoggedIn.value) {
      // Redirect to admin page
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Get.offNamed(Routes.ADMIN);
      });
    } else if (memberController.isLoggedIn.value) {
      // Redirect to member page
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Get.offNamed(Routes.MEMBER);
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Panel',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: hijauSage,
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AdminButton(
                label: 'Login Admin',
                onPressed: () {
                  Get.toNamed(Routes.LOGINADMIN);
                },
              ),
              const SizedBox(height: 20),
              AdminButton(
                label: 'Login Member',
                onPressed: () {
                  Get.toNamed(Routes.LOGINMEMBER);
                },
              ),
            ],
          )),
    );
  }
}

class AdminButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const AdminButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: hijauSage,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle:
            GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      child: Center(
        child: Text(label),
      ),
    );
  }
}
