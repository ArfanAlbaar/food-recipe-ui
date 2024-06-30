import 'package:flutter/material.dart';
import 'package:foodrecipeapp/app/modules/admin/views/member/managementMember_view.dart';
import 'package:foodrecipeapp/app/widgets/colors.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../models/listMember.dart';
import '../../controllers/admin_controller.dart';

class UpdateMemberView extends StatefulWidget {
  final ListMember member;

  UpdateMemberView({required this.member});

  @override
  State<UpdateMemberView> createState() => _UpdateMemberViewState();
}

class _UpdateMemberViewState extends State<UpdateMemberView> {
  final AdminController controller = Get.find();
  late bool isPremium;

  @override
  void initState() {
    super.initState();
    isPremium = widget.member.premium ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hijauSage,
        title: Text('Update Member'),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Update Premium Status',
              style: GoogleFonts.poppins(
                  fontSize: 24, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 20,
            ),
            SwitchListTile(
              title: Text('Premium'),
              value: isPremium,
              onChanged: (bool value) {
                setState(() {
                  isPremium = value;
                });
              },
              activeColor: Colors.green,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: hijauSage,
                fixedSize: Size(Get.width, 40),
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              ),
              onPressed: () {
                controller.updateMember(widget.member.username, isPremium);
                Get.off(ManagementMemberView());
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
