// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
// import '../../../../widgets/colors.dart';
// import '../../controllers/admin_controller.dart';

// class ManagementMember extends StatelessWidget {
//   final AdminController controller = Get.put(AdminController());

//   ManagementMember({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Manajemen Data Member',
//           style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: hijauSage,
//         actions: [
//           IconButton(
//               onPressed: () {},
//               icon: const Icon(Iconsax.add5))
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Obx(() {
//           if (controller.isLoading.value) {
//             return Center(child: CircularProgressIndicator());
//           } else {
//             return ListView.builder(
//               itemCount: controller.members.length,
//               itemBuilder: (context, index) {
//                 final member = controller.members[index];
//                 return Container(
//                   padding: const EdgeInsets.all(20),
//                   margin: const EdgeInsets.only(bottom: 10),
//                   width: Get.width,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: hijauSage.withOpacity(0.1),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Wrap(
//                         children: [
//                           Text(
//                             "${index + 1}.",
//                             style: GoogleFonts.poppins(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 20,
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 10,
//                           ),
//                           Text(
//                             member.name,
//                             style: GoogleFonts.poppins(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 20,
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 10,
//                           ),
//                           Icon(
//                             member.premium ? Icons.check_circle : Icons.cancel,
//                             color: member.premium ? Colors.green : Colors.red,
//                             size: 20,
//                           ),
//                           const SizedBox(
//                             width: 10,
//                           ),
//                           Text(
//                             member.lastLogin.toString(),
//                             style: GoogleFonts.poppins(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 20,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Wrap(
//                         children: [
//                           IconButton(
//                             color: Colors.blue[400],
//                             onPressed: () {},
//                             icon: const Icon(Iconsax.edit_25),
//                           ),
//                           IconButton(
//                             color: Colors.red[400],
//                             onPressed: () {},
//                             icon: const Icon(Iconsax.trash),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 );
//               },
//             );
//           }
//         }),
//       ),
//     );
//   }
// }
