import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pg_managment/core/utils/appRichText.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/commonConstant.dart';
import 'package:pg_managment/core/utils/size_utils.dart';
import 'package:pg_managment/presentation/student_list_screen/student_list_model.dart';
import 'package:pg_managment/routes/app_routes.dart';
import 'package:pg_managment/widgets/custom_app_text_form_field.dart';
import 'package:pg_managment/widgets/custom_image_view.dart';
import 'controller/student_list_screen_controller.dart';

class StudentListScreen extends GetWidget<StudentListScreenController> {
  const StudentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.primaryWhite,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ColorConstant.primary,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon:   Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomImageView(
                    height: 40,
                    width: 40,
                    imagePath:  'assets/images/left-arrow.png' ,color: ColorConstant.primaryWhite),
              ),),
          title: Text(
            'All Student',
            style: PMT.appStyle(
                size: 20,
                // fontWeight: FontWeight.w600,
                fontColor: ColorConstant.primaryWhite),
          ),
        ),
        body: SafeArea(
          child: Obx(
            () => controller.isLoading.value
                ? Center(
                    child: CircularProgressIndicator(
                      color: ColorConstant.primary,
                    ),
                  )
                : Column(
                    children: [
                      vBox(10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        child: CustomAppTextFormField(
                          variant: TextFormFieldVariant.OutlineGray200,
                          hintText: 'Search Student',
                          onChanged: (value) {
                            controller.searchStudent(value);
                          },
                        ),
                      ),
                      vBox(10),
                      Text(
                        'Total Student :- ${controller.studentListModel.value.data?.length}',
                        style: PMT.appStyle(
                            size: 16,
                            fontColor:
                            ColorConstant.primaryBlack),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              controller.studentListSearch.isEmpty == true
                                  ? Column(
                                    children: [
                                      vBox(250),
                                      Center(
                                          child: Text(
                                            'Student Not found',
                                            style: PMT.appStyle(
                                                size: 16,
                                                fontColor:
                                                    ColorConstant.primaryBlack),
                                          ),
                                        ),
                                    ],
                                  )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 16),
                                      child: ListView.builder(
                                        itemCount:
                                            controller.studentListSearch.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          Data? data = controller
                                              .studentListSearch[index];
                                          return Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    color:
                                                        ColorConstant.primary)),
                                            padding: const EdgeInsets.all(8),
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                AppRichText(
                                                    title: 'Name : ',
                                                    value: data.name ?? ''),
                                                vBox(5),AppRichText(
                                                    title: 'Student Id : ',
                                                    value: '${data.id ?? 0}'),
                                                vBox(5),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: AppRichText(
                                                            title:
                                                                'Room no. : ',
                                                            value:
                                                                data.roomNo ??
                                                                    '')),
                                                    Expanded(
                                                        child: AppRichText(
                                                            title: 'Year : ',
                                                            value:
                                                                '${data.year ?? ' '}')),
                                                  ],
                                                ),
                                                vBox(5),
                                                AppRichText(
                                                    title: 'Deposit : ',
                                                    value:
                                                        '${data.deposit ?? ' '}'),
                                                vBox(5),
                                                AppRichText(
                                                    title: 'Mobile Nu. : ',
                                                    value: data.mobile ?? ''),
                                                vBox(5),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    if(CommonConstant.instance.isStudent != 2 &&
                                                        CommonConstant.instance.isStudent != 3)
                                                    Expanded(
                                                        child: IconButton(
                                                            style: IconButton.styleFrom(
                                                                backgroundColor:
                                                                    ColorConstant
                                                                        .primaryBlack
                                                                        .withOpacity(
                                                                            0.3)),
                                                            onPressed: () {
                                                              Get.toNamed(
                                                                  AppRoutes
                                                                      .addStudentScreenRoute,
                                                                  arguments: {
                                                                    "data":
                                                                        data,
                                                                    "isAddEdit":
                                                                        2
                                                                  });
                                                            },
                                                            icon: CustomImageView(
                                                                height: 20,
                                                                width: 20,
                                                                imagePath:  'assets/images/list.png' ,color: ColorConstant.primaryBlack),)),
                                                    hBox(10),
                                                    if(CommonConstant.instance.isStudent != 2  &&
                                                        CommonConstant.instance.isStudent != 3)
                                                    Expanded(
                                                        child: IconButton(
                                                            style: IconButton.styleFrom(
                                                                backgroundColor:
                                                                    ColorConstant
                                                                        .primary
                                                                        .withOpacity(
                                                                            0.3)),
                                                            onPressed: () {
                                                              Get.toNamed(
                                                                  AppRoutes
                                                                      .addStudentScreenRoute,
                                                                  arguments: {
                                                                    "data":
                                                                        data,
                                                                    "isAddEdit":
                                                                        1
                                                                  })?.then(
                                                                  (value) {
                                                                controller
                                                                    .getStudentList();
                                                              });
                                                            },
                                                            icon: CustomImageView(
                                                              height: 20,
                                                              width: 20,
                                                              imagePath:  'assets/images/pencil.png' ,
                                                              color:
                                                                  ColorConstant
                                                                      .primary,
                                                            ))),
                                                    hBox(10),

                                                    Expanded(
                                                        child: IconButton(
                                                            style: IconButton.styleFrom(
                                                                backgroundColor:
                                                                    ColorConstant
                                                                        .green
                                                                        .withOpacity(
                                                                            0.3)),
                                                            onPressed: () {
                                                              Get.toNamed(
                                                                  AppRoutes
                                                                      .addUpdateDayDetailsScreenRoute,
                                                                  arguments: {
                                                                    'student_id':
                                                                        data.id ??
                                                                            '',
                                                                    'name':
                                                                        data.name ??
                                                                            '',
                                                                    'isAdd': 0,
                                                                  });
                                                            },
                                                            icon: CustomImageView(
                                                              height: 20,
                                                              width: 20,
                                                              imagePath:  'assets/images/add.png' ,
                                                              color:
                                                                  ColorConstant
                                                                      .green,
                                                            ))),
                                                    hBox(10),
                                                    if(CommonConstant.instance.isStudent != 2 &&
                                                        CommonConstant.instance.isStudent != 3)
                                                    Expanded(
                                                        child: IconButton(
                                                            style: IconButton.styleFrom(
                                                                backgroundColor:
                                                                    ColorConstant
                                                                        .red
                                                                        .withOpacity(
                                                                            0.3)),
                                                            onPressed: () {
                                                              controller.showDeleteConfirmationDialog(context, () {
                                                                controller
                                                                    .deleteStudent(
                                                                    '${data.id ?? 0}');
                                                              },);

                                                            },
                                                            icon: CustomImageView(
                                                              height: 20,
                                                              width: 20,
                                                              imagePath:  'assets/images/delete.png' ,
                                                              color:
                                                                  ColorConstant
                                                                      .red,
                                                            ))),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ));
  }
}
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pg_managment/core/utils/appRichText.dart';
// import 'package:pg_managment/core/utils/app_fonts.dart';
// import 'package:pg_managment/core/utils/color_constant.dart';
// import 'package:pg_managment/core/utils/size_utils.dart';
// import 'package:pg_managment/presentation/student_list_screen/student_list_model.dart';
// import 'package:pg_managment/routes/app_routes.dart';
// import 'package:pg_managment/widgets/custom_app_text_form_field.dart';
// import 'package:pg_managment/widgets/custom_image_view.dart';
// import 'controller/student_list_screen_controller.dart';
//
// class StudentListScreen extends GetWidget<StudentListScreenController> {
//   const StudentListScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: ColorConstant.primary,
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () => Get.back(),
//           icon: Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: CustomImageView(
//               height: 20,
//               width: 20,
//               imagePath: 'assets/images/left-arrow.png',
//               color: ColorConstant.primaryWhite,
//             ),
//           ),
//         ),
//         title: Text(
//           'All Students',
//           style: PMT.appStyle(
//             size: 20,
//             fontWeight: FontWeight.w600,
//             fontColor: ColorConstant.primaryWhite,
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: Obx(
//               () => controller.isLoading.value
//               ? Center(
//             child: CircularProgressIndicator(
//               color: ColorConstant.primary,
//             ),
//           )
//               : Column(
//             children: [
//               // Search and Header Section
//               Container(
//                 color: Colors.white,
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     // Search Field
//                     Container(
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFF8F9FA),
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: Colors.grey.withOpacity(0.2),
//                         ),
//                       ),
//                       child: TextField(
//                         onChanged: (value) => controller.searchStudent(value),
//                         decoration: InputDecoration(
//                           hintText: 'Search students...',
//                           hintStyle: PMT.appStyle(
//                             size: 14,
//                             fontColor: Colors.grey[600]!,
//                           ),
//                           prefixIcon: Icon(
//                             Icons.search,
//                             color: Colors.grey[600],
//                             size: 20,
//                           ),
//                           border: InputBorder.none,
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 12,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     // Student Count
//                     Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 6,
//                           ),
//                           decoration: BoxDecoration(
//                             color: ColorConstant.primary.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Text(
//                             'Total: ${controller.studentListModel.value.data?.length ?? 0}',
//                             style: PMT.appStyle(
//                               size: 14,
//                               fontWeight: FontWeight.w600,
//                               fontColor: ColorConstant.primary,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               // Student List
//               Expanded(
//                 child: controller.studentListSearch.isEmpty
//                     ? _buildEmptyState()
//                     : ListView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: controller.studentListSearch.length,
//                   itemBuilder: (context, index) {
//                     Data? data = controller.studentListSearch[index];
//                     return _buildStudentCard(data, context);
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 80,
//             height: 80,
//             decoration: BoxDecoration(
//               color: Colors.grey.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(40),
//             ),
//             child: Icon(
//               Icons.search_off,
//               size: 40,
//               color: Colors.grey[400],
//             ),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'No students found',
//             style: PMT.appStyle(
//               size: 18,
//               fontWeight: FontWeight.w600,
//               fontColor: Colors.grey[600]!,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Try adjusting your search criteria',
//             style: PMT.appStyle(
//               size: 14,
//               fontColor: Colors.grey[500]!,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStudentCard(Data? data, BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Student Info Section
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Name and ID Row
//                 Row(
//                   children: [
//                     Container(
//                       width: 50,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         color: ColorConstant.primary.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(25),
//                       ),
//                       child: Center(
//                         child: Text(
//                           (data?.name ?? '').isNotEmpty
//                               ? data!.name!.substring(0, 1).toUpperCase()
//                               : 'S',
//                           style: PMT.appStyle(
//                             size: 20,
//                             fontWeight: FontWeight.bold,
//                             fontColor: ColorConstant.primary,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             data?.name ?? 'Unknown',
//                             style: PMT.appStyle(
//                               size: 15,
//                               fontWeight: FontWeight.w600,
//                               fontColor: Colors.black87,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             'ID: ${data?.id ?? 0}',
//                             style: PMT.appStyle(
//                               size: 14,
//                               fontColor: Colors.grey[600]!,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 // Student Details Grid
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF8F9FA),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: _buildInfoItem(
//                               'Room No.',
//                               data?.roomNo ?? 'N/A',
//                               Icons.room,
//                             ),
//                           ),
//                           Expanded(
//                             child: _buildInfoItem(
//                               'Year',
//                               '${data?.year ?? 'N/A'}',
//                               Icons.calendar_today,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 12),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: _buildInfoItem(
//                               'Deposit',
//                               '₹${data?.deposit ?? 0}',
//                               Icons.account_balance_wallet,
//                             ),
//                           ),
//                           Expanded(
//                             child: _buildInfoItem(
//                               'Mobile',
//                               data?.mobile ?? 'N/A',
//                               Icons.phone,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Action Buttons Section
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: const Color(0xFFFAFBFC),
//               borderRadius: const BorderRadius.only(
//                 bottomLeft: Radius.circular(16),
//                 bottomRight: Radius.circular(16),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: _buildActionButton(
//                     'View',
//                     Icons.visibility,
//                     Colors.blue,
//                         () => Get.toNamed(
//                       AppRoutes.addStudentScreenRoute,
//                       arguments: {"data": data, "isAddEdit": 2},
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: _buildActionButton(
//                     'Edit',
//                     Icons.edit,
//                     Colors.orange,
//                         () => Get.toNamed(
//                       AppRoutes.addStudentScreenRoute,
//                       arguments: {"data": data, "isAddEdit": 1},
//                     )?.then((value) => controller.getStudentList()),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: _buildActionButton(
//                     'Add Details',
//                     Icons.add_circle,
//                     Colors.green,
//                         () => Get.toNamed(
//                       AppRoutes.addUpdateDayDetailsScreenRoute,
//                       arguments: {
//                         'student_id': data?.id ?? '',
//                         'name': data?.name ?? '',
//                         'isAdd': 0,
//                       },
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: _buildActionButton(
//                     'Delete',
//                     Icons.delete,
//                     Colors.red,
//                         () => controller.showDeleteConfirmationDialog(
//                       context,
//                           () => controller.deleteStudent('${data?.id ?? 0}'),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoItem(String label, String value, IconData icon) {
//     return Row(
//       children: [
//         Icon(
//           icon,
//           size: 16,
//           color: Colors.grey[600],
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: PMT.appStyle(
//                   size: 12,
//                   fontColor: Colors.grey[600]!,
//                 ),
//               ),
//               Text(
//                 value,
//                 style: PMT.appStyle(
//                   size: 14,
//                   fontWeight: FontWeight.w600,
//                   fontColor: Colors.black87,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildActionButton(
//       String label,
//       IconData icon,
//       Color color,
//       VoidCallback onPressed,
//       ) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 8),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(
//             color: color.withOpacity(0.3),
//             width: 1,
//           ),
//         ),
//         child: Column(
//           children: [
//             Icon(
//               icon,
//               size: 18,
//               color: color,
//             ),
//             const SizedBox(height: 4),
//             Text(
//               label,
//               style: PMT.appStyle(
//                 size: 11,
//                 fontWeight: FontWeight.w500,
//                 fontColor: color,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
