import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'controller/notification_screen_controller.dart';

class NotificationScreen extends GetWidget<NotificationScreenController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: PMT.appStyle(size: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: ColorConstant.primaryWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: ColorConstant.primaryWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_active_outlined,
              size: 80,
              color: ColorConstant.primary,
            ),
            SizedBox(height: 20),
            Text(
              "No New Notifications",
              style: PMT.appStyle(size: 18, fontColor: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
