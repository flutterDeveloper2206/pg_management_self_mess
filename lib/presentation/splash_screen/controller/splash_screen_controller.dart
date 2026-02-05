import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pg_managment/core/utils/commonConstant.dart';
import 'package:pg_managment/core/utils/pref_utils.dart';
import 'package:pg_managment/core/utils/string_constant.dart';
import 'package:pg_managment/core/utils/notification_service.dart';
import 'package:pg_managment/routes/app_routes.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    CommonConstant.instance.isStudent =
        PrefUtils.getInt(StringConstants.isStudent);
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
    super.onInit();
  }
}
