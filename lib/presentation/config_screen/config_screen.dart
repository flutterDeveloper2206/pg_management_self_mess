import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/size_utils.dart';
import 'package:pg_managment/widgets/custom_app_text_form_field.dart';
import '../../widgets/custom_elavated_button.dart';
import 'controller/config_screen_controller.dart';

class ConfigScreen extends GetWidget<ConfigScreenController> {
  const ConfigScreen({super.key});

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
            'Config',
            style: PMT.appStyle(
                size: 20,
                // fontWeight: FontWeight.w600,
                fontColor: ColorConstant.primaryWhite),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                vBox(20),
                titleWidget(
                    title: 'Total Days',
                    hintText: 'Total Days',
                    textInputType: TextInputType.number,

                    controller: controller.totalDaysController),
  titleWidget(
                    title: 'Eaten Days',
                    hintText: 'Eaten Days',
                    textInputType: TextInputType.number,

                    controller: controller.eatenDaysController),

                titleWidget(
                    title: 'Simple Guest Amount',
                    textInputType: TextInputType.number,
                    hintText: 'Simple Guest Amount',
                    controller: controller.simpleGuestAmountController),
                titleWidget(
                    title: 'Feast Guest Amount',
                    hintText: 'Feast Guest Amount',
                    textInputType: TextInputType.number,
                    controller: controller.feastGuestAmountController),
               AppElevatedButton(
                  buttonName: 'Save',
                  onPressed: () {
                    controller.save();
                  },
                )

              ],
            ),
          ),
        ),);
  }
  Widget titleWidget(
      {required String title,
        required String hintText,
        required TextEditingController controller,
        TextInputType? textInputType,
        bool? readOnly,
        int? maxLine,
        Function()? onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: PMT.appStyle(
              size: 14,
              fontWeight: FontWeight.w600,
              fontColor: ColorConstant.primary),
        ),
        vBox(5),
        CustomAppTextFormField(
          readOnly: readOnly,
          maxLines: maxLine,
          textInputType: textInputType,
          controller: controller,
          variant: TextFormFieldVariant.OutlineGray200,
          hintText: hintText,
          onTap: onTap,
        ),
        vBox(20),
      ],
    );
  }
}
