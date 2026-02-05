import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pg_managment/core/utils/appRichText.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/size_utils.dart';
import 'package:pg_managment/presentation/all_details_list_screen/all_details_list_model.dart';
import 'package:pg_managment/routes/app_routes.dart';
import 'package:pg_managment/widgets/bouncing_button.dart';
import 'package:pg_managment/widgets/custom_app_text_form_field.dart';
import 'package:pg_managment/widgets/custom_image_view.dart';
import '../../widgets/custom_elavated_button.dart';
import 'controller/all_details_list_screen_controller.dart';

class AllDetailsListScreen extends GetWidget<AllDetailsListScreenController> {
  const AllDetailsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.primaryWhite,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
          child: AppElevatedButton(
            buttonName: 'Download',
            onPressed: () async {
              controller.showDownloadSheet(context);
            },
          ),
        ),
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
          title: Text(
            'All Student ',
            style: PMT.appStyle(
                size: 20,
                // fontWeight: FontWeight.w600,
                fontColor: ColorConstant.primaryWhite),
          ),
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
                                controller: controller.month,
                                onTap: () {
                                  controller.selectMonth(context);
                                },
                                readOnly: true,
                                variant: TextFormFieldVariant.OutlineGray200,
                                hintText: 'Select Month')),
                        hBox(10),
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
                                  month: controller.month.text,
                                  year: controller.year.text);
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
                        : controller.studentListSearch.isEmpty == true
                            ? Column(
                                children: [
                                  vBox(
                                      MediaQuery.of(context).size.height / 2.7),
                                  Center(
                                    child: Text('No data found'),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  CustomAppTextFormField(
                                    variant:
                                        TextFormFieldVariant.OutlineGray200,
                                    hintText: 'Search Student',
                                    onChanged: (value) {
                                      controller.searchStudent(value);
                                    },
                                  ),
                                  vBox(10),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          width: getWidth(120),
                                          child: Text('Total Collection :',
                                              style: PMT.appStyle(
                                                  size: 14,
                                                  fontColor:
                                                      Colors.grey.shade700))),
                                      Expanded(
                                        child: Text(
                                          '${controller.totalCollection.value.toStringAsFixed(2)}',
                                          // '20000.00',
                                          style: PMT.appStyle(
                                              size: 14,
                                              fontColor: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          width: getWidth(120),
                                          child: Text('Total Remaining :',
                                              style: PMT.appStyle(
                                                  size: 14,
                                                  fontColor:
                                                      Colors.grey.shade700))),
                                      Expanded(
                                        child: Text(
                                          '${controller.totalRemaining.value.toStringAsFixed(2)}',
                                          // '20000.00',
                                          style: PMT.appStyle(
                                              size: 14,
                                              fontColor: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          width: getWidth(120),
                                          child: Text('Total MealDay :',
                                              style: PMT.appStyle(
                                                  size: 14,
                                                  fontColor:
                                                      Colors.grey.shade700))),
                                      Expanded(
                                        child: Text(
                                          '${controller.totalMealDay.value}',
                                          // '20000.00',
                                          style: PMT.appStyle(
                                              size: 14,
                                              fontColor: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          width: getWidth(120),
                                          child: Text(
                                              'Total Attended MealDay :',
                                              style: PMT.appStyle(
                                                  size: 14,
                                                  fontColor:
                                                      Colors.grey.shade700))),
                                      Expanded(
                                        child: Text(
                                          '${controller.totalMealDay.value - controller.totalCutDay.value}',
                                          // '20000.00',
                                          style: PMT.appStyle(
                                              size: 14,
                                              fontColor: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          width: getWidth(120),
                                          child: Text('Total CutDay :',
                                              style: PMT.appStyle(
                                                  size: 14,
                                                  fontColor:
                                                      Colors.grey.shade700))),
                                      Expanded(
                                        child: Text(
                                          '${controller.totalCutDay.value}',
                                          // '20000.00',
                                          style: PMT.appStyle(
                                              size: 14,
                                              fontColor: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount:
                                        controller.studentListSearch.length ??
                                            0,
                                    itemBuilder: (context, index) {
                                      AllData? data =
                                          controller.studentListSearch[index];
                                      return Bounce(
                                        onTap: () {
                                          Get.toNamed(
                                              AppRoutes
                                                  .dayDetailsListScreenRoute,
                                              arguments: {
                                                'student_id':
                                                    data?.studentId ?? '',
                                                'name': data?.studentName ?? ''
                                              })?.then((value) {
                                            controller.getAllStudentDetails(
                                              month: controller.month.text,
                                              year: controller.year.text,
                                            );
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color:
                                                      ColorConstant.primary)),
                                          padding: const EdgeInsets.all(8),
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AppRichText(
                                                  title: 'Student ID : ',
                                                  value:
                                                      '${data.studentId ?? 0}'),
                                              vBox(5),
                                              AppRichText(
                                                  title: 'Student Name : ',
                                                  value:
                                                      data?.studentName ?? ''),
                                              vBox(5),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: AppRichText(
                                                          title: 'Date : ',
                                                          value:
                                                              '${DateFormat("yyyy-MM-dd").format(data?.date ?? DateTime.now())}')),
                                                  Expanded(
                                                      child: AppRichText(
                                                          title: 'Total : ',
                                                          value:
                                                              '${data?.totalAmount ?? ' '}')),
                                                ],
                                              ),
                                              vBox(5),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: AppRichText(
                                                          title: 'Paid: ',
                                                          value:
                                                              '${data?.paidAmount ?? ' '}')),
                                                  Expanded(
                                                      child: AppRichText(
                                                          title: 'Remaining: ',
                                                          value:
                                                              '${data?.remainAmount ?? ' '}')),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
