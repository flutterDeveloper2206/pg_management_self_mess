import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/size_utils.dart';
import 'package:pg_managment/routes/app_routes.dart';
import 'package:pg_managment/widgets/custom_app_text_form_field.dart';
import 'package:pg_managment/widgets/custom_elavated_button.dart';
import 'package:pg_managment/widgets/custom_image_view.dart';
import 'controller/add_student_screen_controller.dart';

class AddStudentScreen extends GetWidget<AddStudentScreenController> {
  AddStudentScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
              color: ColorConstant.primaryWhite,
            ),
          ),
        ),
        title: Obx(
          () => Text(
            controller.isAddEdit.value == 2
                ? 'View Student Details'
                : controller.isAddEdit.value == 1
                ? 'Edit Student'
                : 'Add Student',
            style: PMT.appStyle(
              size: 20,
              fontColor: ColorConstant.primaryWhite,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  vBox(20),
                  Obx(() => _buildProfileImagePicker(context)),
                  vBox(20),
                  titleWidget(
                    readOnly:
                        controller.readOnly.value ||
                        controller.isStudentShow.value,
                    title: 'Name',
                    hintText: 'Enter Your Name',
                    controller: controller.nameController,
                  ),
                  titleWidget(
                    readOnly: controller.readOnly.value,
                    title: 'Name of Hostel',
                    hintText: 'Enter Your Name of Hostel',
                    controller: controller.hostelNameController,
                  ),
                  titleWidget(
                    readOnly:
                        controller.readOnly.value ||
                        controller.isStudentShow.value,
                    title: 'Registration Number / Enrollment ID',
                    hintText: 'Enter Your Registration Number / Enrollment ID',
                    controller: controller.registrationNumberController,
                  ),
                  titleWidget(
                    readOnly: controller.readOnly.value,
                    title: 'College Name / Institute Name',
                    hintText: 'Enter Your College Name / Institute Name',
                    controller: controller.collageNameController,
                  ),
                  titleWidget(
                    readOnly:
                        controller.readOnly.value ||
                        controller.isStudentShow.value,
                    title: 'Email',
                    hintText: 'Enter Your Email',
                    controller: controller.emailController,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: titleWidget(
                          readOnly: controller.readOnly.value,
                          title: 'Room No.',
                          hintText: 'Room No.',
                          controller: controller.roomController,
                        ),
                      ),
                      hBox(20),
                      Expanded(
                        child: titleWidget(
                          readOnly: controller.readOnly.value,
                          title: 'Blood Group',
                          hintText: 'Blood Group',
                          controller: controller.bloodController,
                        ),
                      ),
                    ],
                  ),
                  titleWidget(
                    readOnly:
                        controller.readOnly.value ||
                        controller.isStudentShow.value,
                    title: 'Academic Program (Diploma/UG/PG/Doctoral)',
                    hintText:
                        'Enter Your Academic Program (Diploma/UG/PG/Doctoral)',
                    controller: controller.academicProgramController,
                  ),
                  titleWidget(
                    readOnly: controller.readOnly.value,
                    title: 'Current Year / Semester',
                    textInputType: TextInputType.number,
                    hintText: 'Enter Your Current Year / Semester',
                    controller: controller.currentlyStudyingYearController,
                  ),
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
                          controller: controller.dateController,
                        ),
                      ),
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
                          controller: controller.yearController,
                        ),
                      ),
                    ],
                  ),
                  titleWidget(
                    readOnly:
                        controller.readOnly.value ||
                        controller.isStudentShow.value,
                    title: 'Mobile Number',
                    textInputType: TextInputType.phone,
                    hintText: 'Enter Your Mobile Number',
                    controller: controller.mobileNumberController,
                  ),
                  titleWidget(
                    readOnly:
                        controller.readOnly.value ||
                        controller.isStudentShow.value,
                    title: 'Alternative Mobile Number',
                    textInputType: TextInputType.phone,
                    hintText: 'Enter Your Alternative Mobile Number',
                    controller: controller.alternativeMobileNumberController,
                  ),
                  titleWidget(
                    readOnly:
                        controller.readOnly.value ||
                        controller.isStudentShow.value,
                    title: 'Account Login Password',
                    hintText: 'Enter Your Account Login Password ',
                    controller: controller.passwordController,
                  ),
                  titleWidget(
                    readOnly:
                        controller.readOnly.value ||
                        controller.isStudentShow.value,
                    title: 'Security Deposit (₹) ',
                    textInputType: TextInputType.number,
                    hintText: 'Enter Security Deposit ',
                    controller: controller.depositController,
                  ),
                  titleWidget(
                    readOnly: controller.readOnly.value,
                    title: 'Address',
                    hintText: 'Enter Your Address ',
                    maxLine: 3,
                    controller: controller.addressController,
                  ),
                  titleWidget(
                    readOnly: controller.readOnly.value,
                    title: 'Academic Advisor/Guide Name',
                    hintText: 'Enter Your Academic Advisor/Guide Name ',
                    maxLine: 3,
                    controller: controller.guidController,
                  ),
                  controller.isAddEdit.value != 2
                      ? AppElevatedButton(
                          buttonName: controller.isAddEdit.value == 1
                              ? 'Update '
                              : 'Save',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              controller.updateAddStudent(
                                id: controller.model.value.id.toString(),
                              );
                            }
                          },
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImagePicker(BuildContext context) {
    if (controller.readOnly.value) {
      return Center(
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorConstant.primary.withOpacity(0.5),
                border: Border.all(color: ColorConstant.primary, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: controller.profileImageUrl.value.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: controller.profileImageUrl.value,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: ColorConstant.primary,
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.person, size: 60, color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    return Center(
      child: GestureDetector(
        onTap: () => _showImagePickerOptions(context),
        child: Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorConstant.primary.withOpacity(0.5),
                border: Border.all(color: ColorConstant.primary, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: controller.selectedImage.value != null
                    ? Image.file(
                        File(controller.selectedImage.value!.path),
                        fit: BoxFit.cover,
                      )
                    : (controller.profileImageUrl.value.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: controller.profileImageUrl.value,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: ColorConstant.primary,
                                ),
                              ),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.white,
                            )),
              ),
            ),
            // if (controller.isStudentShow.value)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: ColorConstant.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Select Source",
              style: PMT.appStyle(size: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImagePickerOption(
                  icon: Icons.camera_alt,
                  label: "Camera",
                  onTap: () {
                    Get.back();
                    controller.pickImage(ImageSource.camera);
                  },
                ),
                _buildImagePickerOption(
                  icon: Icons.photo_library,
                  label: "Gallery",
                  onTap: () {
                    Get.back();
                    controller.pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: ColorConstant.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: ColorConstant.primary, size: 30),
          ),
          const SizedBox(height: 8),
          Text(label, style: PMT.appStyle(size: 14)),
        ],
      ),
    );
  }

  Widget titleWidget({
    required String title,
    required String hintText,
    required TextEditingController controller,
    TextInputType? textInputType,
    bool? readOnly,
    Function()? onTap,
    String Function(String?)? validator,
    int? maxLine,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: PMT.appStyle(
            size: 14,
            fontWeight: FontWeight.w600,
            fontColor: ColorConstant.primary,
          ),
        ),
        vBox(5),
        CustomAppTextFormField(
          readOnly: readOnly,
          maxLines: maxLine,
          textInputType: textInputType,
          controller: controller,
          onTap: onTap,
          validator: validator,
          variant: TextFormFieldVariant.OutlineGray200,
          hintText: hintText,
        ),
        vBox(20),
      ],
    );
  }
}
