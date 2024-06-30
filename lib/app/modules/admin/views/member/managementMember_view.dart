import 'package:flutter/material.dart';
import 'package:foodrecipeapp/app/widgets/colors.dart';
import 'package:get/get.dart';

import '../../../../models/listMember.dart';
import '../../controllers/admin_controller.dart';
import 'editmember_view.dart';

class ManagementMemberView extends StatelessWidget {
  final AdminController controller = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    final AdminController controller = Get.find();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchAllMembers();
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: hijauSage,
        title: Text('Management Member'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (controller.members.isEmpty) {
          return Center(child: Text('No members available'));
        } else {
          return ListView.builder(
            itemCount: controller.members.length,
            itemBuilder: (context, index) {
              ListMember member = controller.members[index];
              return Column(
                children: [
                  ListTile(
                    title: Text(member.name),
                    subtitle: Text(member.phoneNumber),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("${member.lastLogin}"),
                        SizedBox(
                          width: 20,
                        ),
                        Icon(member.premium ?? false
                            ? Icons.check
                            : Icons.close),
                        SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          color: Colors.blue,
                          onPressed: () =>
                              Get.to(() => UpdateMemberView(member: member)),
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
                  Divider(
                    thickness: 2,
                  ),
                ],
              );
            },
          );
        }
      }),
    );
  }
}
