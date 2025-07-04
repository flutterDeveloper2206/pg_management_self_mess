import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/size_utils.dart';
import 'package:pg_managment/widgets/custom_app_text_form_field.dart';
import 'package:pg_managment/widgets/custom_elavated_button.dart';
import 'package:pg_managment/widgets/custom_image_view.dart';
import 'controller/ganarate_bill_screen_controller.dart';

class GanarateBillScreen extends GetWidget<GanarateBillScreenController> {
  const GanarateBillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.primaryWhite,
        bottomNavigationBar: Obx(
          () => controller.isLock.value
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppElevatedButton(
                          isLoading: controller.isLoading.value,
                          buttonName: "Generate Bill",
                          onPressed: () {
                            controller.generateBill(false);
                          },
                        ),
                      ),
                      hBox(10),
                      Expanded(
                        child: AppElevatedButton(
                          isLoading: controller.isLoading.value,
                          buttonName: "Finalize Bill",
                          onPressed: () {
                            controller.generateBill(true);
                          },
                        ),
                      )
                    ],
                  ),
                ),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ColorConstant.primary,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon:Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomImageView(
                    height: 40,
                    width: 40,
                    imagePath:  'assets/images/left-arrow.png' ,color: ColorConstant.primaryWhite),
              ),),
          title: Text(
            'Bill Details',
            style: PMT.appStyle(
                size: 20,
                // fontWeight: FontWeight.w600,
                fontColor: ColorConstant.primaryWhite),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                vBox(20),
                Center(
                  child: Text(
                    "Date : ${DateFormat('dd-MM-yyyy').format(DateTime.now())}",
                    style: PMT.appStyle(
                        size: 20,
                        fontWeight: FontWeight.bold,
                        fontColor: ColorConstant.primary),
                  ),
                ),
                vBox(40),
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
                          controller.calculateRate(
                              );
                        },
                        child: Text('GO',
                            style: PMT.appStyle(
                                size: 16,
                                fontWeight: FontWeight.bold,
                                fontColor: ColorConstant.primary)))


                  ],
                ),
                vBox(20),
                Text(
                  "Actual Rate",
                  style: PMT.appStyle(
                      size: 16,
                      fontWeight: FontWeight.w500,
                      fontColor: ColorConstant.primary),
                ),
                Obx(
                  () =>  CustomAppTextFormField(
                    hintText: controller.billTotal.value,
                    textInputType: TextInputType.number,
readOnly: true,
                    controller: controller.rateController.value,
                    variant: TextFormFieldVariant.OutlineGray200,
                  ),

                ),
                vBox(10),Text(
                  "Modify Rate",
                  style: PMT.appStyle(
                      size: 16,
                      fontWeight: FontWeight.w500,
                      fontColor: ColorConstant.primary),
                ),
                Obx(
                  () =>  CustomAppTextFormField(
                    hintText: '0.00',
                    textInputType: TextInputType.number,
                    controller: controller.rateController.value,
                    variant: TextFormFieldVariant.OutlineGray200,
                  ),

                ),
                vBox(10),
                Text(
                  "Guest Cash",
                  style: PMT.appStyle(
                      size: 16,
                      fontWeight: FontWeight.w500,
                      fontColor: ColorConstant.primary),
                ),
                CustomAppTextFormField(
                  hintText: 'Guest Cash',
                  textInputType: TextInputType.number,
                  controller: controller.guestCashController.value,
                  variant: TextFormFieldVariant.OutlineGray200,
                ),
              ],
            ),
          ),
        ));
  }
}
