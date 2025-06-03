import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pg_managment/core/utils/appRichText.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/size_utils.dart';
import 'package:pg_managment/presentation/student_list_screen/student_list_model.dart';
import 'package:pg_managment/routes/app_routes.dart';
import 'package:pg_managment/widgets/custom_app_text_form_field.dart';
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
              icon: const Icon(
                Icons.arrow_back_ios,
                color: ColorConstant.primaryWhite,
              )),
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
                                                    value: data?.name ?? ''),
                                                vBox(5),AppRichText(
                                                    title: 'Student Id : ',
                                                    value: '${data?.id ?? 0}'),
                                                vBox(5),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: AppRichText(
                                                            title:
                                                                'Room no. : ',
                                                            value:
                                                                data?.roomNo ??
                                                                    '')),
                                                    Expanded(
                                                        child: AppRichText(
                                                            title: 'Year : ',
                                                            value:
                                                                '${data?.year ?? ' '}')),
                                                  ],
                                                ),
                                                vBox(5),
                                                AppRichText(
                                                    title: 'Deposit : ',
                                                    value:
                                                        '${data?.deposit ?? ' '}'),
                                                vBox(5),
                                                AppRichText(
                                                    title: 'Mobile Nu. : ',
                                                    value: data?.mobile ?? ''),
                                                vBox(5),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
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
                                                            icon: Icon(
                                                              Icons.view_list,
                                                              color: ColorConstant
                                                                  .primaryBlack,
                                                            ))),
                                                    hBox(10),
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
                                                            icon: Icon(
                                                              Icons.edit,
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
                                                                        data?.id ??
                                                                            '',
                                                                    'name':
                                                                        data?.name ??
                                                                            '',
                                                                    'isAdd': 0,
                                                                  });
                                                            },
                                                            icon: Icon(
                                                              Icons.add,
                                                              color:
                                                                  ColorConstant
                                                                      .green,
                                                            ))),
                                                    hBox(10),
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
                                                                    '${data?.id ?? 0}');
                                                              },);

                                                            },
                                                            icon: Icon(
                                                              Icons.delete,
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
