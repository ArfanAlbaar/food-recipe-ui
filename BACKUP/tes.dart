// child: Obx(() {
//             if (controller.isLoading.value) {
//               return Center(child: CircularProgressIndicator());
//             } else {
//               var recipes = controller.getRecipesByCategory(category);
//               if (recipes.isEmpty) {
//                 return Center(child: Text('No recipes found'));
//               } else {
//                 return Row(
//                   children: List.generate(
//                     recipes.length,
//                     (id) => GestureDetector(
//                       onTap: () {
//                         Get.to(
//                           () => RecipeDetailView(recipeId: recipes[id]['id']),
//                         );
//                       },
//                       child: Container(
//                         margin: const EdgeInsets.only(right: 20),
//                         padding: const EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         width: 200, // Width of each recipe card
//                         child: Column(
//                           children: [
//                             Image.network(recipes[id]['imgLink'],
//                                 height: 100,
//                                 width: double.infinity,
//                                 fit: BoxFit.cover),
//                             SizedBox(height: 8),
//                             Text(
//                               recipes[id]['recipeName'],
//                               textAlign: TextAlign
//                                   .center, // Align text center horizontally
//                               style: GoogleFonts.poppins(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             SizedBox(height: 8),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               }
//             }
//           }),