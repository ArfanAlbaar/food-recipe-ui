import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../models/premium_list.dart';
import '../../../../widgets/colors.dart';
import '../../controllers/admin_controller.dart';

class EditPremiumView extends StatefulWidget {
  final int id;

  const EditPremiumView({super.key, required this.id});

  @override
  _EditPremiumViewState createState() => _EditPremiumViewState();
}

class _EditPremiumViewState extends State<EditPremiumView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  bool _isLoading = true;
  late PremiumList _premium;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _fetchPremium();
  }

  Future<void> _fetchPremium() async {
    try {
      _premium = await Get.find<AdminController>().getPremiumById(widget.id);
      _nameController.text = _premium.premiumName;
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to load premium details',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Get.find<AdminController>()
          .editPremium(widget.id, _nameController.text)
          .then((success) {
        if (success) {
          Get.back();
          Get.snackbar('Success', 'Premium name updated successfully',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white);
        } else {
          Get.snackbar('Error', 'Failed to update premium name',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        }
      }).catchError((e) {
        Get.snackbar('Error', 'Failed to update premium name',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Premium',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: hijauSage,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Premium Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a premium name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submit,
                      child: Text(
                        'Update',
                        style: GoogleFonts.poppins(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: hijauSage,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
