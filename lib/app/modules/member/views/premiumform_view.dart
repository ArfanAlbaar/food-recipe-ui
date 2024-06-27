import 'package:flutter/material.dart';
import 'package:foodrecipeapp/app/modules/member/controllers/member_controller.dart';
import 'package:foodrecipeapp/app/widgets/colors.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../routes/app_pages.dart';
import '../../admin/controllers/admin_controller.dart';

class PremiumformView extends GetView<MemberController> {
  const PremiumformView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();

    Get.lazyPut<AdminController>(
      () => AdminController(),
    );
    final AdminController adminController = Get.find();

    // Check if already logged in
    if (controller.isLoggedIn.value) {
      // Redirect to member page
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Get.offNamed(Routes.MEMBER);
      });
    } else if (adminController.isLoggedIn.value) {
      // Redirect to member page
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Get.offNamed(Routes.MEMBER);
      });
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hijauSage,
        title: Text(
          'Upgrade ke Premium',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lengkapi Data Anda',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: GoogleFonts.poppins(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Nama Anda',
                        labelStyle: GoogleFonts.poppins(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: GoogleFonts.poppins(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Telepon',
                        labelStyle: GoogleFonts.poppins(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.phone),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nomor Telepon tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            String username = usernameController.text.trim();
                            String name = nameController.text.trim();
                            String password = passwordController.text.trim();
                            String phoneNumber =
                                phoneNumberController.text.trim();
                            controller.registerMember(
                                username, name, password, phoneNumber);
                            if (formKey.currentState!.validate()) {
                              Get.snackbar(
                                "Berhasil",
                                "Data anda berhasil disimpan",
                                backgroundColor: bgColor,
                                colorText: hijauSage,
                              );
                              usernameController.clear();
                              nameController.clear();
                              passwordController.clear();
                              phoneNumberController.clear();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: hijauSage,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Submit',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600)),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.offNamed(
                                Routes.CHOOSELOGIN); //ARAHKAN KE PEMBAYARAN
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: hijauSage,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Cancel',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
