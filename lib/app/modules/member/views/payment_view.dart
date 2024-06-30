import 'package:flutter/material.dart';
import 'package:foodrecipeapp/app/modules/member/controllers/member_controller.dart';
import 'package:foodrecipeapp/app/widgets/colors.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../routes/app_pages.dart';
import '../../admin/controllers/admin_controller.dart';

class PaymentView extends GetView<MemberController> {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneNumberController = TextEditingController();
    final TextEditingController amountController = TextEditingController();

    Get.lazyPut<AdminController>(
      () => AdminController(),
    );
    final AdminController adminController = Get.find();

    if (adminController.isLoggedIn.value) {
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
                      'Cek Data Anda',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      enabled: false,
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Nama Anda',
                        labelStyle: GoogleFonts.poppins(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        enabled: false,
                        labelText: 'Telepon',
                        labelStyle: GoogleFonts.poppins(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.phone),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text("Ketik 15000"),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: amountController,
                      decoration: InputDecoration(
                          labelText: 'Masukkan Jumlah',
                          labelStyle: GoogleFonts.poppins(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Container(
                            margin: EdgeInsets.all(20),
                            child: Text("Rp."),
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Jumlah tidak boleh kosong';
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
                            if (formKey.currentState!.validate()) {
                              // controller.registerMember(
                              //     username, name, password, phoneNumber);
                              Get.snackbar(
                                "Berhasil",
                                "Data anda berhasil disimpan",
                                backgroundColor: bgColor,
                                colorText: hijauSage,
                              );

                              nameController.clear();

                              phoneNumberController.clear();
                              Get.offNamed(Routes.MEMBER);
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
                            Get.back();
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
