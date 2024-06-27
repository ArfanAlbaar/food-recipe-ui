import 'package:flutter/material.dart';
import 'package:foodrecipeapp/app/modules/member/controllers/member_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../../routes/app_pages.dart';
import '../../admin/controllers/admin_controller.dart';

class MemberView extends GetView<MemberController> {
  const MemberView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<AdminController>(
      () => AdminController(),
    );
    final AdminController adminController = Get.find();

    bool checkMember = controller.isLoggedIn.value;

    // Check if already logged in
    if (adminController.isLoggedIn.value) {
      // Redirect to admin page
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Get.offAllNamed(Routes.MEMBER);
      });
    } else if (checkMember) {
      // Redirect to member page
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Get.offNamed(Routes.MEMBER);
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MEMBER PREMIUM',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: checkMember
            ? [
                IconButton(
                    onPressed: () {
                      controller.logoutMember();
                    },
                    icon: const Icon(Iconsax.logout5))
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MemberButton(
              label: 'DOWNLOAD RESEP RAHASIA',
              onPressed: () {
                // Get.to(() => const AdminAddFood()); //DOWNLOAD PDF RECIPE
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MemberButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const MemberButton({Key? key, required this.label, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
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
