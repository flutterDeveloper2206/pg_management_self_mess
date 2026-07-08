import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/size_utils.dart';
import 'package:pg_managment/widgets/custom_app_text_form_field.dart';
import 'package:pg_managment/widgets/custom_elavated_button.dart';
import 'package:pg_managment/widgets/custom_image_view.dart';
import 'controller/ganarate_bill_screen_controller.dart';
import 'package:pg_managment/widgets/responsive_layout.dart';

class GanarateBillScreen extends GetWidget<GanarateBillScreenController> {
  const GanarateBillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.primaryWhite,
      bottomNavigationBar: ResponsiveWrapper(
        maxWidth: 700,
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
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
                        buttonName: "Finalize Bill (lock)",
                        onPressed: () {
                          controller.generateBill(true);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                AppElevatedButton(
                  isLoading: controller.isLoading1.value,
                  buttonName: "Update All Student Bill",
                  onPressed: () {
                    _showUpdateBillDialog(context);
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
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
          icon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomImageView(
              height: 40,
              width: 40,
              imagePath: 'assets/images/left-arrow.png',
              color: ColorConstant.primaryWhite,
            ),
          ),
        ),
        title: Text(
          'Bill Details',
          style: PMT.appStyle(
            size: 20,
            // fontWeight: FontWeight.w600,
            fontColor: ColorConstant.primaryWhite,
          ),
        ),
      ),
      body: SafeArea(
        child: ResponsiveWrapper(
          maxWidth: 700,
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
                      fontColor: ColorConstant.primary,
                    ),
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
                        hintText: 'Select Month',
                      ),
                    ),
                    hBox(10),
                    Expanded(
                      child: CustomAppTextFormField(
                        controller: controller.year,
                        readOnly: true,
                        variant: TextFormFieldVariant.OutlineGray200,
                        onTap: () {
                          controller.selectYear(context);
                        },
                        hintText: 'Select Year',
                      ),
                    ),
                    hBox(10),

                    TextButton(
                      onPressed: () {
                        controller.calculateRate();
                      },
                      child: Text(
                        'GO',
                        style: PMT.appStyle(
                          size: 16,
                          fontWeight: FontWeight.bold,
                          fontColor: ColorConstant.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                vBox(20),
                Text(
                  "Actual Rate",
                  style: PMT.appStyle(
                    size: 16,
                    fontWeight: FontWeight.w500,
                    fontColor: ColorConstant.primary,
                  ),
                ),
                Obx(
                  () => CustomAppTextFormField(
                    hintText: controller.billTotal.value,
                    textInputType: TextInputType.number,
                    readOnly: true,
                    controller: controller.rateController.value,
                    variant: TextFormFieldVariant.OutlineGray200,
                  ),
                ),
                vBox(10),
                Text(
                  "Modify Rate",
                  style: PMT.appStyle(
                    size: 16,
                    fontWeight: FontWeight.w500,
                    fontColor: ColorConstant.primary,
                  ),
                ),
                Obx(
                  () => CustomAppTextFormField(
                    hintText: '0.00',
                    textInputType: TextInputType.number,
                    controller: controller.rateController.value,
                    variant: TextFormFieldVariant.OutlineGray200,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showUpdateBillDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorConstant.primaryWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Update All Student Bills',
            style: PMT.appStyle(
              size: 20,
              fontWeight: FontWeight.w600,
              fontColor: ColorConstant.primary,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Guest Cash",
                style: PMT.appStyle(
                  size: 16,
                  fontWeight: FontWeight.w500,
                  fontColor: ColorConstant.primary,
                ),
              ),
              const SizedBox(height: 8),
              CustomAppTextFormField(
                hintText: 'Guest Cash',
                textInputType: TextInputType.number,
                controller: controller.guestCashController.value,
                variant: TextFormFieldVariant.OutlineGray200,
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: PMT.appStyle(
                  size: 14,
                  fontWeight: FontWeight.w500,
                  fontColor: Colors.grey[600]!,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.updateAllBill();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Text(
                  'Update',
                  style: PMT.appStyle(
                    size: 14,
                    fontWeight: FontWeight.w600,
                    fontColor: ColorConstant.primaryWhite,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
