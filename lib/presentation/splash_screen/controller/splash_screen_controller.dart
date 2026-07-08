import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pg_managment/core/utils/commonConstant.dart';
import 'package:pg_managment/core/utils/pref_utils.dart';
import 'package:pg_managment/core/utils/string_constant.dart';
import 'package:pg_managment/core/utils/notification_service.dart';
import 'package:pg_managment/routes/app_routes.dart';

import 'package:pg_managment/core/utils/version_check_helper.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    CommonConstant.instance.isStudent = PrefUtils.getInt(
      StringConstants.isStudent,
    );
    _checkVersionAndNavigate();
    super.onInit();
  }

  Future<void> _checkVersionAndNavigate() async {
    bool isUpdateForced = await VersionCheckHelper.checkAndShowUpdateDialog();
    if (isUpdateForced) {
      return; // Stop flow and show force update dialog
    }

    Timer(const Duration(seconds: 3), () {
      if (NotificationService.pendingRoute != null) {
        String route = NotificationService.pendingRoute!;
        NotificationService.pendingRoute = null; // Clear it
        Get.offAllNamed(route);
        return;
      }

      if (!kIsWeb &&
          PrefUtils.getString(StringConstants.authToken).isNotEmpty) {
        Get.offAllNamed(AppRoutes.dashboardScreenRoute);
      } else {
        PrefUtils.clearPreferencesData();

        Get.offAllNamed(AppRoutes.loginScreenRoute);
      }
    });
  }
}
