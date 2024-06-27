import 'package:flutter/material.dart';
import 'package:foodrecipeapp/app/modules/home/controllers/recipe_controller.dart';
import 'package:foodrecipeapp/app/modules/home/widgetshome/card_items.dart';
import 'package:foodrecipeapp/app/widgets/colors.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

// import '../../foodDetail/views/food_detail_view.dart';
import '../widgetshome/list_recipes.dart';
import '../widgetshome/sambutan_items.dart';
import '../widgetshome/tableAnggota.dart';

class HomeView extends GetView<RecipeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // * Sambutan dan iconbutton
                const Sambutan(),
                const SizedBox(
                  height: 40,
                ),
// * CARD
                const CardItems(),
                const SizedBox(
                  height: 30,
                ),
                ListRecipes(
                  category: "BREAKFAST",
                  icon: Iconsax.sun_fog5,
// ontap1: () {},
                ),
                const SizedBox(
                  height: 20,
                ),
                ListRecipes(
                  category: "LUNCH",
                  icon: Iconsax.sun_15,

                  // ontap1: () {},
                ),
                const SizedBox(
                  height: 20,
                ),
                ListRecipes(
                  category: "DINNER",
                  icon: Iconsax.moon5,

                  // ontap1: () {},
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "Daftar Anggota Kelompok",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 25, bottom: 20),
                  child: Divider(
                    thickness: 2,
                    color: hijauSage,
                  ),
                ),
                const TableAnggota(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
