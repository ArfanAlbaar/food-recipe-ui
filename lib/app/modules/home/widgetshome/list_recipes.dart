import 'package:flutter/material.dart';
import 'package:foodrecipeapp/app/modules/recipeDetail/views/recipe_detail_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/recipe_controller.dart';
// import '../views/food_detail_view.dart'; // Import your detail view file here

class ListRecipes extends StatelessWidget {
  final String category;
  final IconData icon;

  ListRecipes({
    required this.category,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RecipeController controller = Get.find();

    // Fetch recipes based on category when widget is built
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: Icon(icon),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        // * LIST RECIPES
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            } else {
              var recipes = controller.getRecipesByCategory(category);
              if (recipes.isEmpty) {
                return Center(child: Text('No recipes found'));
              } else {
                return Row(
                  children: List.generate(
                    recipes.length,
                    (id) => GestureDetector(
                      onTap: () {
                        Get.to(
                          () => RecipeDetailView(recipeId: recipes[id]['id']),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 20),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 200, // Width of each recipe card
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(recipes[id]['imgLink'],
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover),
                            SizedBox(height: 8),
                            Text(
                              recipes[id]['recipeName'],
                              textAlign: TextAlign
                                  .center, // Align text center horizontally
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            // Text(
                            //   'Ingredients: ${recipes[id]['ingredients']}',
                            //   style: GoogleFonts.poppins(
                            //     fontSize: 14,
                            //   ),
                            //   maxLines: 2, // Limit to 2 lines for ingredients
                            //   overflow: TextOverflow
                            //       .ellipsis, // Ellipsis for overflow
                            // ),
                            // SizedBox(height: 8),
                            // Text(
                            //   'Instructions: ${recipes[id]['instructions']}',
                            //   style: GoogleFonts.poppins(
                            //     fontSize: 14,
                            //   ),
                            //   maxLines: 2, // Limit to 2 lines for instructions
                            //   overflow: TextOverflow
                            //       .ellipsis, // Ellipsis for overflow
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            }
          }),
        ),
      ],
    );
  }
}
