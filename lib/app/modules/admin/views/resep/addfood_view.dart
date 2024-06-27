import 'package:flutter/material.dart';
import 'package:foodrecipeapp/app/models/resep.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../widgets/colors.dart';
import '../../controllers/admin_controller.dart';

// ignore: must_be_immutable
class AddFood extends StatelessWidget {
  final AdminController controller = Get.find();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bahanController = TextEditingController();
  final TextEditingController langkahController = TextEditingController();
  final TextEditingController imgLinkController = TextEditingController();
  final List<String> categories = [
    'DINNER',
    'LUNCH',
    'BREAKFAST',
  ];
  String selectedCategory = 'DINNER';

  AddFood({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Data Makanan',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: hijauSage,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AdminTextField(
                  controller: nameController,
                  label: 'Nama Makanan',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama makanan tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                AdminTextField(
                  controller: bahanController,
                  label: 'Bahan',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bahan tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                AdminTextField(
                  controller: langkahController,
                  label: 'Langkah Memasak',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Langkah memasak tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                AdminTextField(
                  controller: imgLinkController,
                  label: 'Link Gambar',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Link gambar tidak boleh kosong';
                    }
                    return null;
                  },
                ),
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
                    if (_formKey.currentState?.validate() ?? false) {
                      Resep newFood = Resep(
                        recipeName: nameController.text,
                        ingredients: bahanController.text,
                        instructions: langkahController.text,
                        category: selectedCategory,
                        favorite: controller.isFavorite.value,
                        imgLink: imgLinkController.text,
                      );
                      controller.addFood(newFood);
                      print(newFood);
                    } else {
                      Get.snackbar('Error', 'Lengkapi datanya dengan benar');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: hijauSage,
                      fixedSize: Size(Get.width, 40)),
                  child: const Text('Tambah'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AdminTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const AdminTextField({
    Key? key,
    this.controller,
    this.label,
    this.keyboardType = TextInputType.text,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        autocorrect: false,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
