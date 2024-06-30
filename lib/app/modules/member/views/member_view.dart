import 'package:flutter/material.dart';
import 'package:foodrecipeapp/app/modules/member/controllers/member_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../../routes/app_pages.dart';
import '../../../widgets/colors.dart';
import '../../admin/controllers/admin_controller.dart';
import 'card_payment.dart';

class MemberView extends GetView<MemberController> {
  const MemberView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensuring the data is fetched when the page is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchAllPremiums();
    });
    Get.lazyPut<AdminController>(
      () => AdminController(),
    );
    final AdminController adminController = Get.find();

    return Obx(() {
      bool checkMember = controller.isLoggedIn.value;

      // Check if already logged in
      if (adminController.isLoggedIn.value) {
        // Redirect to admin page
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAllNamed(Routes.ADMIN);
        });
      } else if (checkMember) {
        // Redirect to member page
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offNamed(Routes.MEMBER);
        });
      }

      if (controller.isLoading.value) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'MEMBER PREMIUM',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: hijauSage,
          ),
          body: Center(child: CircularProgressIndicator()),
        );
      } else {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'MEMBER PREMIUM',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: hijauSage,
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
              children: [
                const CardPaymentItems(), // Add CardItems widget here
                const SizedBox(height: 20),
                Obx(() {
                  if (controller.isDownloading.value) {
                    return CircularProgressIndicator();
                  } else {
                    return Text(controller.status.value);
                  }
                }),
                controller.premiums.isEmpty
                    ? Center(child: Text('No premium recipes found'))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: controller.premiums.length,
                          itemBuilder: (context, index) {
                            final recipe = controller.premiums[index];
                            return MemberButton(
                              label: recipe.premiumName,
                              onPressed: () {
                                controller.downloadByMember(recipe.id);
                              },
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        );
      }
    });
  }
}

class MemberButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const MemberButton({Key? key, required this.label, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 10),
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.teal.withOpacity(0.1),
      ),
      child: ElevatedButton(
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
      ),
    );
  }
}
