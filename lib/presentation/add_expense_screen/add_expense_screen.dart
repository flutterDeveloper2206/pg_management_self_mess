import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/size_utils.dart';
import 'package:pg_managment/routes/app_routes.dart';
import 'package:pg_managment/widgets/custom_elavated_button.dart';
import 'package:pg_managment/widgets/custom_image_view.dart';
import '../../widgets/custom_app_text_form_field.dart';
import 'controller/add_expense_screen_controller.dart';

class AddExpenseScreen extends GetWidget<AddExpenseScreenController> {
  const AddExpenseScreen({super.key});

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
                    imagePath:  'assets/images/left-arrow.png' ,color: ColorConstant.primaryWhite),
              ),),
          title: Obx(
            () => Text(
              controller.isAddEdit.value == 2
                  ? 'View Expense'
                  : controller.isAddEdit.value == 1
                      ? 'Edit Expense'
                      : 'Add Expense',
              style: PMT.appStyle(
                  size: 20,
                  // fontWeight: FontWeight.w600,
                  fontColor: ColorConstant.primaryWhite),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  vBox(20),
                  titleWidget(
                      readOnly: controller.readOnly.value,
                      title: 'Item',
                      hintText: 'Enter Your Item',
                      controller: controller.itemController),
                  titleWidget(
                      readOnly: true,
                      title: 'Date',
                      textInputType: TextInputType.phone,
                      hintText: 'Date',
                      controller: controller.dateController,
                      onTap: () {
                        controller.selectDate(context);
                      }),
                  titleWidget(
                      readOnly: controller.readOnly.value,
                      title: 'Amount',
                      textInputType: TextInputType.number,
                      hintText: 'Enter Amount ',
                      controller: controller.amountController),
                  titleWidget(
                      readOnly: controller.readOnly.value,
                      title: 'Remark',
                      hintText: 'Enter Your Remark',
                      maxLine: 3,
                      controller: controller.remarkController),
                  controller.isAddEdit.value != 2
                      ? AppElevatedButton(
                          buttonName: controller.isAddEdit.value == 1
                              ? 'Update '
                              : 'Save',
                          onPressed: () {
                            controller.addExpense();
                          },
                        )
                      : SizedBox.shrink()
                ],
              ),
            ),
          ),
        ));
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
