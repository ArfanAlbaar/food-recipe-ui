import 'package:flutter/material.dart';
import 'package:foodrecipeapp/app/modules/admin/controllers/admin_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../widgets/colors.dart';

class TransactionView extends GetView<AdminController> {
  // final AdminController controller = Get.put(AdminController());

  TransactionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch transactions when the view is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchTransactions();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transaction Management',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: hijauSage,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else if (controller.transactions.isEmpty) {
            return Center(child: Text("No transactions found"));
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Amount')),
                  DataColumn(label: Text('Timestamp')),
                  DataColumn(label: Text('Username')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: List<DataRow>.generate(
                  controller.transactions.length,
                  (index) {
                    final transaction = controller.transactions[index];
                    return DataRow(cells: [
                      DataCell(Text((index + 1).toString())),
                      DataCell(Text(transaction.amount.toString())),
                      DataCell(Text(transaction.timestamp.toString())),
                      DataCell(Text(transaction.member.username)),
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
                    ]);
                  },
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}
