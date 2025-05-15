import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/size_utils.dart';
import 'package:pg_managment/widgets/custom_app_text_form_field.dart';
import 'package:pg_managment/widgets/custom_elavated_button.dart';
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
              icon: const Icon(
                Icons.arrow_back_ios,
                color: ColorConstant.primaryWhite,
              )),
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
                Text(
                  "Calculate Rate",
                  style: PMT.appStyle(
                      size: 16,
                      fontWeight: FontWeight.w500,
                      fontColor: ColorConstant.primary),
                ),
                Obx(
                  () =>  CustomAppTextFormField(
                    hintText: controller.billTotal.value,
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
