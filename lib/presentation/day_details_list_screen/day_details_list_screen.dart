import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pg_managment/core/utils/appRichText.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/commonConstant.dart';
import 'package:pg_managment/core/utils/size_utils.dart';
import 'package:pg_managment/presentation/all_details_list_screen/all_details_list_model.dart';
import 'package:pg_managment/routes/app_routes.dart';
import 'package:pg_managment/widgets/bouncing_button.dart';
import 'package:pg_managment/widgets/custom_image_view.dart';
import 'controller/day_details_list_screen_controller.dart';
import 'package:pg_managment/widgets/custom_app_text_form_field.dart';

class DayDetailsListScreen extends GetWidget<DayDetailsListScreenController> {
  const DayDetailsListScreen({super.key});

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
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomImageView(
                  height: 40,
                  width: 40,
                  imagePath: 'assets/images/left-arrow.png',
                  color: ColorConstant.primaryWhite),
            ),
          ),
          title: Obx(
            () => Text(
              '${controller.studentName.value} Details ',
              style: PMT.appStyle(
                  size: 16,
                  // fontWeight: FontWeight.w600,
                  fontColor: ColorConstant.primaryWhite),
            ),
          ),
          actions: [
            CommonConstant.instance.isStudent == 1 ||
                    CommonConstant.instance.isStudent == 2 ||
                    CommonConstant.instance.isStudent == 3
                ? Bounce(
                    onTap: () {
                      Get.toNamed(AppRoutes.addUpdateDayDetailsScreenRoute,
                          arguments: {
                            'student_id': controller.studentId.value,
                            'name': controller.studentName.value,
                            'isAdd': 0,
                          })?.then((value) {
                        controller.getAllStudentDetails(
                            month: '',
                            year: controller.year.text,
                            studentId: controller.studentId.value.toString());
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: ColorConstant.primaryWhite),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      child: Text(
                        '+ ADD Details',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ColorConstant.primary),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        body: SafeArea(
          child: Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: CustomAppTextFormField(
                                controller: controller.year,
                                readOnly: true,
                                variant: TextFormFieldVariant.OutlineGray200,
                                onTap: () {
                                  controller.selectYear(context);
                                },
                                hintText: 'Select Year')),
                        hBox(10),
                        TextButton(
                            onPressed: () {
                              controller.getAllStudentDetails(
                                  month: '',
                                  year: controller.year.text,
                                  studentId:
                                      controller.studentId.value.toString());
                            },
                            child: Text('GO',
                                style: PMT.appStyle(
                                    size: 16,
                                    fontWeight: FontWeight.bold,
                                    fontColor: ColorConstant.primary)))
                      ],
                    ),
                    vBox(20),
                    controller.isLoading.value
                        ? Column(
                            children: [
                              vBox(MediaQuery.of(context).size.height / 2.7),
                              Center(
                                child: CircularProgressIndicator(
                                  color: ColorConstant.primary,
                                ),
                              ),
                            ],
                          )
                        : controller.allStudentListModel.value.data?.isEmpty ??
                                true
                            ? Column(
                                children: [
                                  vBox(
                                      MediaQuery.of(context).size.height / 2.7),
                                  Center(
                                    child: Text('No data found'),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: controller.allStudentListModel.value
                                        .data?.length ??
                                    0,
                                itemBuilder: (context, index) {
                                  AllData? data = controller
                                      .allStudentListModel.value.data?[index];
                                  return Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: ColorConstant.primary),
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AppRichText(
                                                  title: 'Date : ',
                                                  color: ColorConstant
                                                      .primaryWhite,
                                                  value:
                                                      '${DateFormat("yyyy-MM-dd").format(data?.date ?? DateTime.now())}'),
                                              vBox(5),
                                              AppRichText(
                                                  title: 'Total : ',
                                                  color: ColorConstant
                                                      .primaryWhite,
                                                  value:
                                                      '${data?.totalAmount ?? ' '}'),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Bounce(
                                              onTap: () {
                                                Get.toNamed(
                                                    AppRoutes
                                                        .addUpdateDayDetailsScreenRoute,
                                                    arguments: {
                                                      'student_id': controller
                                                          .studentId.value,
                                                      'name': controller
                                                          .studentName.value,
                                                      'isAdd': 2,
                                                      'data': data
                                                    });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color: ColorConstant
                                                        .primaryWhite),
                                                child: CustomImageView(
                                                  height: 20,
                                                  width: 20,
                                                  imagePath:
                                                      'assets/images/list.png',
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            CommonConstant.instance.isStudent == 1 ||
                                                CommonConstant.instance.isStudent == 2 ||
                                                CommonConstant.instance.isStudent == 3
                                                ? Bounce(
                                                    onTap: () {
                                                      Get.toNamed(
                                                          AppRoutes
                                                              .addUpdateDayDetailsScreenRoute,
                                                          arguments: {
                                                            'student_id':
                                                                controller
                                                                    .studentId
                                                                    .value,
                                                            'name': controller
                                                                .studentName
                                                                .value,
                                                            'isAdd': 1,
                                                            'data': data
                                                          })?.then((value) {
                                                        controller
                                                            .getAllStudentDetails(
                                                                month: '',
                                                                year: controller
                                                                    .year.text,
                                                                studentId: controller
                                                                    .studentId
                                                                    .value
                                                                    .toString());
                                                      });
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          color: ColorConstant
                                                              .primaryWhite),
                                                      child: CustomImageView(
                                                        height: 20,
                                                        width: 20,
                                                        imagePath:
                                                            'assets/images/pencil.png',
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox.shrink(),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            CommonConstant.instance.isStudent == 1 ||
                                                CommonConstant.instance.isStudent == 2 ||
                                                CommonConstant.instance.isStudent == 3
                                                ? Bounce(
                                                    onTap: () {
                                                      controller
                                                          .showDeleteConfirmationDialog(
                                                        context,
                                                        () {
                                                          controller
                                                              .deleteStudentDetails(
                                                                  data?.id
                                                                      .toString());
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          color: ColorConstant
                                                              .primaryWhite),
                                                      child: CustomImageView(
                                                        height: 20,
                                                        width: 20,
                                                        imagePath:
                                                            'assets/images/delete.png',
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox.shrink(),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
