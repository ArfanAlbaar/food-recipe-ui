import 'package:flutter/material.dart';
import 'package:foodrecipeapp/app/widgets/colors.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart'; // Import printing package
import '../../../../models/listMember.dart';
import '../../controllers/admin_controller.dart';
import 'editmember_view.dart';

class ManagementMemberView extends StatelessWidget {
  final AdminController controller = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchAllMembers();
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: hijauSage,
        title: Text(
          'Management Member',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => _printMemberReport(
                context), // Panggil fungsi cetak saat tombol ditekan
            icon: Icon(Iconsax.printer5),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (controller.members.isEmpty) {
          return Center(
            child: Text(
              'No members available',
              style: GoogleFonts.poppins(),
            ),
          );
        } else {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DataTable(
                headingRowColor: MaterialStateColor.resolveWith(
                  (states) => hijauSage,
                ),
                columns: [
                  DataColumn(
                    label: Text(
                      'Name',
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Phone Number',
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Last Login',
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Premium',
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Actions',
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: controller.members.asMap().entries.map((entry) {
                  int index = entry.key;
                  ListMember member = entry.value;
                  return DataRow(
                    color: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (index % 2 == 0) {
                          return Colors.grey.withOpacity(0.1);
                        }
                        return null;
                      },
                    ),
                    cells: [
                      DataCell(Text(
                        member.name,
                        style: GoogleFonts.poppins(),
                      )),
                      DataCell(Text(
                        member.phoneNumber,
                        style: GoogleFonts.poppins(),
                      )),
                      DataCell(Text(
                        "${member.lastLogin}",
                        style: GoogleFonts.poppins(),
                      )),
                      DataCell(
                        Icon(
                          member.premium ?? false
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: member.premium ?? false
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              color: Colors.blue,
                              onPressed: () => Get.to(
                                  () => UpdateMemberView(member: member)),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () =>
                                  controller.deleteMember(member.username),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        }
      }),
    );
  }

  // Fungsi untuk mencetak laporan anggota
  Future<void> _printMemberReport(BuildContext context) async {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        build: (pw.Context context) {
          // ignore: deprecated_member_use
          return pw.Table.fromTextArray(
            headers: ['Name', 'Phone Number', 'Last Login', 'Premium'],
            data: controller.members.map((member) {
              return [
                member.name,
                member.phoneNumber,
                member.lastLogin.toString(),
                member.premium ?? false ? 'Yes' : 'No'
              ];
            }).toList(),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) => doc.save(),
    );
  }
}
