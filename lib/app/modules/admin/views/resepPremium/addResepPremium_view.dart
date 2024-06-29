import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../widgets/colors.dart';
import '../../controllers/admin_controller.dart';

class AddResepPremiumView extends StatefulWidget {
  const AddResepPremiumView({super.key});

  @override
  _ResepPremiumViewState createState() => _ResepPremiumViewState();
}

class _ResepPremiumViewState extends State<AddResepPremiumView> {
  String? _fileName;
  PlatformFile? _pickedFile;
  final TextEditingController _nameController = TextEditingController();

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
        _pickedFile = result.files.single;
      });
    }
  }

  void _submit() async {
    if (_nameController.text.isEmpty || _pickedFile == null) {
      Get.snackbar('Error', 'Please provide a name and pick a file');
      return;
    }

    try {
      await Get.find<AdminController>()
          .addPremiumWithPdf(_nameController.text, _pickedFile!);
      Get.back(); // Kembali ke halaman sebelumnya setelah berhasil
    } catch (error) {
      Get.snackbar('Error', error.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Resep Premium',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: hijauSage,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nama Premium',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: hijauSage, width: 2.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Icon(Icons.attach_file, color: hijauSage),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _fileName ?? 'Pilih File',
                      style: GoogleFonts.poppins(fontSize: 16.0),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _pickFile,
                    child: Text(
                      'Choose File',
                      style: GoogleFonts.poppins(),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hijauSage,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text(
                'Tambah',
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
    );
  }
}
