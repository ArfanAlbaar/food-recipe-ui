import 'package:flutter/material.dart';
import 'package:foodrecipeapp/app/modules/admin/controllers/admin_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart'; // Import printing package

import '../../../../widgets/colors.dart';

class TransactionView extends GetView<AdminController> {
  TransactionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AdminController controller = Get.find();
    // Fetch transactions when the view is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchTransactions();
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: hijauSage,
        title: Text(
          'Transaction Management',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => _printTransactionReport(
                context), // Panggil fungsi cetak saat tombol ditekan
            icon: Icon(Iconsax.printer5),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else if (controller.transactions.isEmpty) {
            return Center(
              child: Text(
                "No transactions found",
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            );
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor:
                    MaterialStateColor.resolveWith((states) => hijauSage),
                columnSpacing: 20.0,
                columns: [
                  DataColumn(
                    label: Text(
                      'ID',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Username',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Tanggal',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Jumlah',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Actions',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: List<DataRow>.generate(
                  controller.transactions.length,
                  (index) {
                    final transaction = controller.transactions[index];
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
                          transaction.id.toString(),
                          style: GoogleFonts.poppins(),
                        )),
                        DataCell(Text(
                          transaction.member.username,
                          style: GoogleFonts.poppins(),
                        )),
                        DataCell(Text(
                          transaction.timestamp.toString(),
                          style: GoogleFonts.poppins(),
                        )),
                        DataCell(Text(
                          transaction.amount.toString(),
                          style: GoogleFonts.poppins(),
                        )),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                controller.deleteTransaction(transaction.id);
                              },
                            ),
                          ],
                        )),
                      ],
                    );
                  },
                ),
              ),
            );
          }
        }),
      ),
    );
  }

  // Fungsi untuk mencetak laporan anggota
  Future<void> _printTransactionReport(BuildContext context) async {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        build: (pw.Context context) {
          // ignore: deprecated_member_use
          return pw.Table.fromTextArray(
            cellAlignment: pw.Alignment.center,
            headers: ['ID', 'Username', 'Nama', 'No. Tel', 'Jumlah', 'Tanggal'],
            data: controller.transactions.map((transaction) {
              return [
                transaction.id,
                transaction.member.username,
                transaction.member.name,
                transaction.member.phoneNumber,
                transaction.amount,
                transaction.timestamp
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
