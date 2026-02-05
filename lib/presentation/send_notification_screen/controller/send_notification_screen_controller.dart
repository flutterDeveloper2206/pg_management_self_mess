import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pg_managment/ApiServices/api_service.dart';
import 'package:pg_managment/core/utils/app_network_urls.dart';
import 'package:pg_managment/core/utils/navigation_service.dart';
import 'package:pg_managment/core/utils/progress_dialog_utils.dart';

class SendNotificationScreenController extends GetxController {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  RxBool isLoading = false.obs;
  RxString selectedType = 'announcement'.obs;

  @override
  void onInit() {
    dateController.text = DateTime.now().toString().split(' ')[0];
    super.onInit();
  }

  // Future<void> selectDate(BuildContext context) async {
  //   DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );
  //   if (picked != null) {
  //     dateController.text = picked.toString().split(' ')[0];
  //   }
  // }

  Future<void> sendNotification() async {
    if (titleController.text.isEmpty || bodyController.text.isEmpty) {
      AppFlushBars.appCommonFlushBar(
        context: NavigationService.navigatorKey.currentContext!,
        message: 'Please enter both title and body',
        success: false,
      );
      return;
    }
        dateController.text = DateTime.now().toString().split(' ')[0];

    isLoading.value = true;

    Map<String, dynamic> body = {
      'title': titleController.text,
      'body': bodyController.text,
      'type': selectedType.value,
      'payload': {
        'date': dateController.text,
      }
    };

    await ApiService()
        .callPostApi(
      body: body,
      url: NetworkUrls.sendNotificationUrl,
      showLoader: true,
    )
        .then((value) {
      isLoading.value = false;
      if (value != null && (value.statusCode == 200|| value.statusCode == 201)) {
        titleController.clear();
        bodyController.clear();
        AppFlushBars.appCommonFlushBar(
          context: NavigationService.navigatorKey.currentContext!,
          message: 'Notification sent successfully',
          success: true,
        );
      } else {
        AppFlushBars.appCommonFlushBar(
          context: NavigationService.navigatorKey.currentContext!,
          message: 'Failed to send notification',
          success: false,
        );
      }
    });
  }

  @override
  void onClose() {
    titleController.dispose();
    bodyController.dispose();
    dateController.dispose();
    super.onClose();
  }
}
