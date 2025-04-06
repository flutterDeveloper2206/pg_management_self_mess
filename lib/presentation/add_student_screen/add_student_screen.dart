import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/size_utils.dart';
import 'package:pg_managment/routes/app_routes.dart';
import 'package:pg_managment/widgets/custom_elavated_button.dart';
import '../../widgets/custom_app_text_form_field.dart';
import 'controller/add_student_screen_controller.dart';

class AddStudentScreen extends GetWidget<AddStudentScreenController> {
  const AddStudentScreen({super.key});

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
              icon: Icon(
                Icons.arrow_back_ios,
                color: ColorConstant.primaryWhite,
              )),
          title: Text(
            'Add Student',
            style: PMT.appStyle(
                size: 20,
                // fontWeight: FontWeight.w600,
                fontColor: ColorConstant.primaryWhite),
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
                      title: 'Name',
                      hintText: 'Enter Your Name',
                      controller: controller.nameController),
                  titleWidget(
                      title: 'Hostel Name',
                      hintText: 'Enter Your Hostel Name',
                      controller: controller.hostelNameController),
                  titleWidget(
                      title: 'Email',
                      hintText: 'Enter Your Email',
                      controller: controller.hostelNameController),
                  Row(
                    children: [
                      Expanded(
                          child: titleWidget(
                              title: 'Room No.',
                              hintText: 'Room No.',
                              controller: controller.hostelNameController)),
                      hBox(20),
                      Expanded(
                          child: titleWidget(
                              title: 'Blood Group',
                              hintText: 'Blood Group',
                              controller: controller.hostelNameController)),
                    ],
                  ),
                  titleWidget(
                      title: 'Currently Pursuing',
                      hintText: 'Enter Your Currently Pursuing',
                      controller: controller.currentlyPursuingController),
                  titleWidget(
                      title: 'Currently Studying Year',
                      hintText: 'Enter Your Currently Studying Year',
                      controller: controller.currentlyStudyingYearController),
                  Row(
                    children: [
                      Expanded(
                          child: titleWidget(
                              title: 'Date',
                              textInputType: TextInputType.phone,

                              hintText: 'Date',
                              controller: controller.dateController)),
                      hBox(20),
                      Expanded(
                          child: titleWidget(
                              title: 'Year',
                              textInputType: TextInputType.phone,

                              hintText: 'Year',
                              controller: controller.yearController)),
                    ],
                  ),
                  titleWidget(
                      title: 'Mobile Number',
                      textInputType: TextInputType.phone,
                      hintText: 'Enter Your Mobile Number',
                      controller: controller.mobileNumberController),
                  titleWidget(
                      title: 'Alternative Mobile Number',
                      textInputType: TextInputType.phone,
                      hintText: 'Enter Your Alternative Mobile Number',
                      controller: controller.alternativeMobileNumberController),
                  titleWidget(
                      title: 'Password',
                      hintText: 'Enter Your Password ',
                      controller: controller.passwordController),
                  titleWidget(
                      title: 'Deposit',
                      textInputType: TextInputType.number,
                      hintText: 'Enter Deposit ',
                      controller: controller.depositController),
                  titleWidget(
                      title: 'Address',
                      hintText: 'Enter Your Address ',
                      maxLine: 3,
                      controller: controller.addressController),
                  titleWidget(
                      title: 'Advisor Guide',
                      hintText: 'Enter Your Advisor Guide ',
                      maxLine: 3,
                      controller: controller.guidController),
                  AppElevatedButton(
                    buttonName: 'Save',
                    onPressed: () {},
                  )
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
        int? maxLine}) {
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
          maxLines: maxLine,
          textInputType: textInputType,
          controller: controller,
          variant: TextFormFieldVariant.OutlineGray200,
          hintText: hintText,
        ),
        vBox(20),
      ],
    );
  }
}
