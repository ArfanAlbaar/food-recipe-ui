import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:foodrecipeapp/app/widgets/colors.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../models/resep.dart';
import '../controllers/recipe_detail_controller.dart';

class RecipeDetailView extends StatelessWidget {
  final int recipeId;
  final RecipeDetailController controller = Get.put(RecipeDetailController());

  RecipeDetailView({required this.recipeId, Key? key}) : super(key: key) {
    controller.fetchRecipeById(recipeId);
  }

  @override
  Widget build(BuildContext context) {
    // final RecipeDetailController controller =
    //     Get.find<RecipeDetailController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: hijauSage, // Example color
        title: Obx(() => Text(
              controller.resep.value?.recipeName ?? 'Loading...',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            )),
        centerTitle: true,
        actions: [
          Obx(() {
            if (controller.resep.value != null) {
              return IconButton(
                icon: const Icon(Iconsax.printer),
                onPressed: () {
                  printRecipe(controller.resep.value!.toJson());
                },
              );
            } else {
              return Container(); // Return empty container if recipe is null
            }
          }),
        ],
      ),
      body: Obx(() => controller.resep.value != null
          ? buildRecipeContent(controller.resep.value!)
          : Center(child: CircularProgressIndicator())),
    );
  }

  Widget buildRecipeContent(Resep resep) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(resep.imgLink),
                  fit: BoxFit.cover,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  resep.imgLink,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              resep.recipeName,
              style: GoogleFonts.poppins(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Ingredients:',
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              resep.ingredients,
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              'Instructions:',
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              resep.instructions,
              style: GoogleFonts.poppins(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> printRecipe(Map<String, dynamic> resep) async {
    final pdf = pw.Document();

    // Fetch the image from the network
    final response = await http.get(Uri.parse(resep['imgLink']));
    final imageBytes = response.bodyBytes;

    // Create a PdfImage from the bytes
    final pdfImage = pw.MemoryImage(imageBytes);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Nama Resep: ${resep['recipeName']}',
                style: pw.TextStyle(fontSize: 24),
              ),
              pw.SizedBox(height: 10),
              pw.Image(pdfImage, width: 300),
              pw.SizedBox(height: 10),
              pw.Text('Bahan-bahan:',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.Text(resep['ingredients']),
              pw.SizedBox(height: 10),
              pw.Text('Cara Pembuatan:',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.Text(resep['instructions']),
            ],
          );
        },
      ),
    );

    final Uint8List pdfBytes = await pdf.save();

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
    );
  }
}
