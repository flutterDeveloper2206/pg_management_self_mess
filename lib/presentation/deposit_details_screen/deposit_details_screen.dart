import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pg_managment/core/utils/appRichText.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/size_utils.dart';
import 'package:pg_managment/presentation/deposit_details_screen/controller/deposit_details_screen_controller.dart';
import 'package:pg_managment/widgets/custom_elavated_button.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../student_list_screen/student_list_model.dart';

class DepositDetailsScreen extends GetWidget<DepositDetailsScreenController> {
  const DepositDetailsScreen({super.key});

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
            'Deposit Details',
            style: PMT.appStyle(
                size: 20,
                // fontWeight: FontWeight.w600,
                fontColor: ColorConstant.primaryWhite),
          ),
        ),
        body: SafeArea(
          child: Obx(
            () => controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                      color: ColorConstant.primary,
                    ),
                  )
                : controller.studentListModel.value.data != null &&
                        controller.studentListModel.value.data!.isEmpty
                    ? const Center(
                        child: Text('No data found'),
                      )
                    : Stack(
              clipBehavior: Clip.none,
                      alignment: Alignment.bottomCenter,
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        width: getWidth(120),
                                        child: Text('Total Deposit :',
                                            style: PMT.appStyle(
                                                size: 14,
                                                fontColor: Colors.grey.shade700))),
                                    Expanded(
                                      child: Text(
                                        '${controller.totalDeposit.value}' ?? 'N/A',
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
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: controller
                                            .studentListModel.value.data?.length ??
                                        0,
                                    // 3,
                                    itemBuilder: (context, index) {
                                      Data? data = controller
                                          .studentListModel.value.data?[index];

                                      return Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                                color: ColorConstant.primary)),
                                        padding: const EdgeInsets.all(8),
                                        margin: const EdgeInsets.only(bottom: 10),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppRichText(
                                                title: 'Student Name : ',
                                                value: data?.name ?? ''),
                                            vBox(5),
                                            AppRichText(
                                                title: 'Student ID : ',
                                                value: '${data?.id ?? ' '}'),
                                            vBox(5),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: AppRichText(
                                                      title: 'Deposit : ',
                                                      value:
                                                      '${data?.deposit ?? ' '}'),
                                                ),
                                                Expanded(
                                                  child:   AppRichText(
                                                      title: 'Date : ',
                                                      value: data?.date ?? ''),

                                                ),
                                              ],
                                            ),
                                            vBox(5),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                vBox(50)
                              ],
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16,right: 16,bottom: 10),
                          child: AppElevatedButton(
                            buttonName: 'Download PDF',
                            onPressed: () async {
                              final pdfData = await controller.generatePdf();
                              await Printing.sharePdf(
                                bytes: pdfData,

                                filename: 'student Deposit Repost ${DateTime.now()}.pdf',
                              );
                            },
                          ),
                        ),
                      ],
                    ),
          ),
        ));
  }
}
