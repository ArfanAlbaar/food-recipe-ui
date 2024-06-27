import 'package:flutter/material.dart';
import 'package:foodrecipeapp/app/modules/admin/controllers/admin_controller.dart';
import 'package:foodrecipeapp/app/widgets/colors.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../routes/app_pages.dart';

class LoginAdminView extends GetView<AdminController> {
  const LoginAdminView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    // Check if already logged in
    if (controller.isLoggedIn.value) {
      // Redirect to admin page
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Get.offNamed(Routes.ADMIN);
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Selamat Datang ADMINISTRATOR ",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: hijauSage,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Silahkan Login Menggunakan Akun Administrator Masing-masing",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 50),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email, color: hijauSage),
                  labelText: "Username",
                  labelStyle: GoogleFonts.poppins(color: hijauSage),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: hijauSage),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock, color: hijauSage),
                  labelText: "Password",
                  labelStyle: GoogleFonts.poppins(color: hijauSage),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: hijauSage),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    String username = usernameController.text.trim();
                    String password = passwordController.text.trim();
                    controller.loginAdmin(username, password);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hijauSage,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Login",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
