import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/size_utils.dart';
import 'package:pg_managment/routes/app_routes.dart';
import 'package:pg_managment/widgets/bouncing_button.dart';
import 'package:pg_managment/widgets/custom_elavated_button.dart';
import 'package:pg_managment/widgets/custom_image_view.dart';
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
                  ? 'View Student Details'
                  : controller.isAddEdit.value == 1
                      ? 'Edit Student'
                      : 'Add Student',
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
                      readOnly: controller.readOnly.value||controller.isStudentShow.value,
                      title: 'Name',
                      hintText: 'Enter Your Name',
                      controller: controller.nameController),
                  titleWidget(
                      readOnly: controller.readOnly.value,
                      title: 'Name of Hostel',
                      hintText: 'Enter Your Name of Hostel',
                      controller: controller.hostelNameController),
                  titleWidget(
                      readOnly: controller.readOnly.value||controller.isStudentShow.value,
                      title: 'Registration Number / Enrollment ID',
                      hintText: 'Enter Your Registration Number / Enrollment ID',
                      controller: controller.registrationNumberController),
                  titleWidget(
                      readOnly: controller.readOnly.value,
                      title: 'College Name / Institute Name',
                      hintText: 'Enter Your College Name / Institute Name',
                      controller: controller.collageNameController),
                  titleWidget(
                      readOnly: controller.readOnly.value||controller.isStudentShow.value,
                      title: 'Email',
                      hintText: 'Enter Your Email',
                      controller: controller.emailController),
                  Row(
                    children: [
                      Expanded(
                          child: titleWidget(
                              readOnly: controller.readOnly.value,
                              title: 'Room No.',
                              hintText: 'Room No.',
                              controller: controller.roomController)),
                      hBox(20),
                      Expanded(
                          child: titleWidget(
                              readOnly: controller.readOnly.value,
                              title: 'Blood Group',
                              hintText: 'Blood Group',
                              controller: controller.bloodController)),
                    ],
                  ),
                  titleWidget(
                      readOnly: controller.readOnly.value||controller.isStudentShow.value,
                      title: 'Academic Program (Diploma/UG/PG/Doctoral)',
                      hintText: 'Enter Your Academic Program (Diploma/UG/PG/Doctoral)',
                      controller: controller.academicProgramController),
                  titleWidget(
                      readOnly: controller.readOnly.value,
                      title: 'Current Year / Semester',
                      textInputType: TextInputType.number,
                      hintText: 'Enter Your Current Year / Semester',
                      controller: controller.currentlyStudyingYearController),
                  Row(
                    children: [
                      Expanded(
                          child: titleWidget(
                              readOnly: true,
                              title: 'Date Of Mess Enrollment',
                              onTap: () {
                                controller.selectDate(context);
                              },
                              textInputType: TextInputType.phone,
                              hintText: 'Date',
                              controller: controller.dateController)),
                      hBox(20),
                      Expanded(
                          child: titleWidget(
                              readOnly: true,
                              title: 'Year',
                              onTap: () {
                                controller.selectYear(context);
                              },
                              textInputType: TextInputType.phone,
                              hintText: 'Year',
                              controller: controller.yearController)),
                    ],
                  ),
                  titleWidget(
                      readOnly: controller.readOnly.value||controller.isStudentShow.value,
                      title: 'Mobile Number',
                      textInputType: TextInputType.phone,
                      hintText: 'Enter Your Mobile Number',
                      controller: controller.mobileNumberController),
                  titleWidget(
                      readOnly: controller.readOnly.value||controller.isStudentShow.value,
                      title: 'Alternative Mobile Number',
                      textInputType: TextInputType.phone,
                      hintText: 'Enter Your Alternative Mobile Number',
                      controller: controller.alternativeMobileNumberController),
                  titleWidget(
                      readOnly: controller.readOnly.value||controller.isStudentShow.value,
                      title: 'Account Login Password',
                      hintText: 'Enter Your Account Login Password ',
                      controller: controller.passwordController),
                  titleWidget(
                      readOnly: controller.readOnly.value||controller.isStudentShow.value,
                      title: 'Security Deposit (₹) ',
                      textInputType: TextInputType.number,
                      hintText: 'Enter Security Deposit ',
                      controller: controller.depositController),
                  titleWidget(
                      readOnly: controller.readOnly.value,
                      title: 'Address',
                      hintText: 'Enter Your Address ',
                      maxLine: 3,
                      controller: controller.addressController),
                  titleWidget(
                      readOnly: controller.readOnly.value,
                      title: 'Academic Advisor/Guide Name',
                      hintText: 'Enter Your Academic Advisor/Guide Name ',
                      maxLine: 3,
                      controller: controller.guidController),
                  controller.isAddEdit.value != 2
                      ? AppElevatedButton(
                          buttonName: controller.isAddEdit.value == 1
                              ? 'Update '
                              : 'Save',
                          onPressed: () {
                            controller.updateAddStudent(
                                id: controller.model.value.id.toString());
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
      Function()? onTap,
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
          readOnly: readOnly,
          maxLines: maxLine,
          textInputType: textInputType,
          controller: controller,
          onTap: onTap,
          variant: TextFormFieldVariant.OutlineGray200,
          hintText: hintText,
        ),
        vBox(20),
      ],
    );
  }
}
