import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/resep.dart';
import '../../../../widgets/colors.dart';
import '../../controllers/admin_controller.dart';

import 'addfood_view.dart'; // Import your Resep model

// ignore: must_be_immutable
class EditFood extends StatelessWidget {
  final AdminController controller = Get.find();
  final Resep food;
  final int index;

  final TextEditingController nameController;
  final TextEditingController bahanController;
  final TextEditingController langkahController;
  final TextEditingController imgLinkController;
  final List<String> categories = [
    'DINNER',
    'LUNCH',
    'BREAKFAST',
  ];
  late String selectedCategory;
  bool isFavorite;

  EditFood({required this.food, required this.index, Key? key})
      : nameController = TextEditingController(text: food.recipeName),
        bahanController = TextEditingController(text: food.ingredients),
        langkahController = TextEditingController(text: food.instructions),
        imgLinkController = TextEditingController(text: food.imgLink),
        selectedCategory = food.category,
        isFavorite = food.favorite,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!categories.contains(selectedCategory)) {
      selectedCategory = categories.first;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Data Resep',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: hijauSage,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AdminTextField(controller: nameController, label: 'Nama Resep'),
              AdminTextField(controller: bahanController, label: 'Bahan'),
              AdminTextField(
                  controller: langkahController, label: 'Langkah Memasak'),
              AdminTextField(
                  controller: imgLinkController, label: 'Link Gambar'),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: selectedCategory,
                items: categories
                    .map((category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedCategory = value;
                  }
                },
              ),
              const SizedBox(height: 16),
              Obx(() => SwitchListTile(
                    title: Text('Favorite'),
                    value: controller.isFavorite.value,
                    onChanged: (bool value) {
                      controller.isFavorite.value = value;
                    },
                    activeColor: Colors.green,
                  )),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Resep updatedFood = Resep(
                    recipeName: nameController.text,
                    ingredients: bahanController.text,
                    instructions: langkahController.text,
                    category: selectedCategory,
                    favorite: isFavorite,
                    imgLink: imgLinkController.text,
                  );
                  controller.editFood(index, updatedFood);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: hijauSage, fixedSize: Size(Get.width, 40)),
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
