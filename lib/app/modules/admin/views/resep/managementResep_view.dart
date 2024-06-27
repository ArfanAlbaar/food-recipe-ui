import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../widgets/colors.dart';
import '../../../recipeDetail/views/recipe_detail_view.dart';
import '../../controllers/admin_controller.dart';
import 'addfood_view.dart';
import 'editfood_view.dart'; // Import your Makanan model

class ManagementResep extends GetView<AdminController> {
  const ManagementResep({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Ensuring the data is fetched when the page is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchAllRecipes();
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
              onPressed: () => Get.to(() => AddFood()),
              icon: const Icon(Iconsax.add5))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (controller.recipes.isEmpty) {
              return Center(child: Text('No recipes found'));
            } else {
              return ListView.builder(
                itemCount: controller.recipes.length,
                itemBuilder: (context, index) {
                  final food = controller.recipes[index];
                  return GestureDetector(
                    onTap: () {
                      // Implement your onTap logic here
                      Get.to(() => RecipeDetailView(recipeId: food.id!));
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
                          Wrap(
                            children: [
                              Text(
                                "${index + 1}.",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                food.recipeName,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          Wrap(
                            children: [
                              IconButton(
                                color: Colors.blue[400],
                                onPressed: () {
                                  Get.to(
                                    EditFood(
                                      food: food,
                                      index: food.id!,
                                    ),
                                  );
                                },
                                icon: const Icon(Iconsax.edit_25),
                              ),
                              IconButton(
                                color: Colors.red[400],
                                onPressed: () {
                                  controller.deleteFood(food.id!);
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
