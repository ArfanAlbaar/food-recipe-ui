import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../widgets/colors.dart';

class AddResepPdfView extends StatefulWidget {
  const AddResepPdfView({super.key});

  @override
  _ResepPremiumViewState createState() => _ResepPremiumViewState();
}

class _ResepPremiumViewState extends State<AddResepPdfView> {
  String? _fileName;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
      });
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
              onPressed: () {
                // Implement submit action here
              },
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
