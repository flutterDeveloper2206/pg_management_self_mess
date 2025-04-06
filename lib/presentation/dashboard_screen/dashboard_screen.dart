import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/size_utils.dart';
import 'package:pg_managment/routes/app_routes.dart';
import 'package:pg_managment/widgets/custom_elavated_button.dart';
import 'controller/dashboard_screen_controller.dart';

class DashboardScreen extends GetWidget<DashboardScreenController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.primaryWhite,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ColorConstant.primary,
          centerTitle: true,
          title: Text(
            'Dashboard',
            style: PMT.appStyle(
                size: 24,
                fontWeight: FontWeight.bold,
                fontColor: ColorConstant.primaryWhite),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                vBox(100),
                AppElevatedButton(
                  buttonName: 'All Student',
                  hasGradient: false,
                  onPressed: () {
                    Get.toNamed(AppRoutes.studentListScreenRoute);
                  },
                ),
                vBox(20),
                AppElevatedButton(
                  buttonName: 'Add Student',
                  hasGradient: false,
                  onPressed: () {
                    Get.toNamed(AppRoutes.addStudentScreenRoute);
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
