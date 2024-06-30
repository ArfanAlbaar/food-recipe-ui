import 'package:flutter/material.dart';
import 'package:foodrecipeapp/app/modules/admin/views/resepPremium/addResepPremium_view.dart';
import 'package:foodrecipeapp/app/modules/admin/views/resepPremium/editResepPremium.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../widgets/colors.dart';
import '../../controllers/admin_controller.dart';

// import 'addfood_view.dart';
// import 'editfood_view.dart'; // Import your Makanan model

class ManagementResepPremium extends GetView<AdminController> {
  const ManagementResepPremium({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AdminController controller = Get.find();
    // Ensuring the data is fetched when the page is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchAllPremiums();
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manajemen Data Resep',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: hijauSage,
        actions: [
          IconButton(
              onPressed: () => Get.off(() => AddResepPremiumView()),
              icon: const Icon(Iconsax.add5))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (controller.premiums.isEmpty) {
              return Center(child: Text('No premium recipes found'));
            } else {
              return ListView.builder(
                itemCount: controller.premiums.length,
                itemBuilder: (context, index) {
                  final premium = controller.premiums[index];
                  return GestureDetector(
                    onTap: () {
                      // Implement your onTap logic here if needed
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 10),
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: hijauSage.withOpacity(0.1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "${index + 1}. ${premium.premiumName}",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Wrap(
                            children: [
                              IconButton(
                                color: Colors.blue[400],
                                onPressed: () {
                                  // Navigate to edit page with premium details
                                  Get.to(EditPremiumView(
                                    id: premium.id,
                                  ));
                                },
                                icon: const Icon(Iconsax.edit_25),
                              ),
                              IconButton(
                                color: Colors.red[400],
                                onPressed: () {
                                  controller.deletePremium(premium.id!);
                                },
                                icon: const Icon(Iconsax.trash),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
        }),
      ),
    );
  }
}
