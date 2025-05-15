import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/size_utils.dart';
import 'controller/student_profile_screen_controller.dart';

class StudentProfileScreen extends GetWidget<StudentProfileScreenController> {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColorConstant.primaryWhite,
      appBar: AppBar(
        backgroundColor: ColorConstant.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: ColorConstant.primaryWhite),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Student Profile",
          style: PMT.appStyle(size: 20, fontColor: ColorConstant.primaryWhite),
        ),
      ),
      body: Obx(
              () {
                final data = controller.model.value.data;

                return   data == null
    ? const Center(child: CircularProgressIndicator())
    : SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: Column(
    children: [
      // Profile Avatar and Name
      CircleAvatar(
        radius: 50,
        backgroundColor: ColorConstant.primary,
        child: Text(
          data.name != null && data.name!.isNotEmpty
              ? data.name![0]
              : '?',
          style: PMT.appStyle( size:36, fontColor: Colors.white),
        ),
      ),
      const SizedBox(height: 10),
      Text(
        data.name ?? 'N/A',
        style: PMT.appStyle( size:22, fontColor: Colors.black, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 4),
      Text(
        data.email ?? '',
        style: PMT.appStyle( size:14, fontColor: Colors.grey),
      ),
      const SizedBox(height: 20),

      // Personal Info Section
      _sectionTitle("Personal Info"),
      _infoRow("Mobile", data.mobile),
      _infoRow("Alternative Mobile", data.alternativeMobile),
      _infoRow("Blood Group", data.bloodGroup),
      _infoRow("Residential Address", data.residentialAddress),

      const SizedBox(height: 20),
      _sectionTitle("Academic Info"),
      _infoRow("Hostel Name", data.hostelName),
      _infoRow("Room No", data.roomNo),
      _infoRow("Currently Pursuing", data.currentlyPursuing),
      _infoRow("Studying Year", "${data.currentlyStudyingYear}"),
      _infoRow("Admission Date", "${data.date?.toLocal().toString().split(' ')[0]}"),
      _infoRow("Passing Year", "${data.year}"),
      _infoRow("Advisor", data.advisorGuide),

      const SizedBox(height: 20),
      _sectionTitle("Finance"),
      _infoRow("Deposit", "₹${data.deposit}"),
    ],
  ),
);
          }

      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          title,
          style: PMT.appStyle( size: 18, fontColor: ColorConstant.primary, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: getWidth(140), child: Text('${label} :', style: PMT.appStyle(size: 14, fontColor: Colors.grey.shade700))),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: PMT.appStyle(size: 14, fontColor: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
