import 'dart:async';

import 'package:get/get.dart';
import 'package:pg_managment/core/utils/commonConstant.dart';
import 'package:pg_managment/core/utils/pref_utils.dart';
import 'package:pg_managment/core/utils/string_constant.dart';
import 'package:pg_managment/routes/app_routes.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    CommonConstant.instance.isStudent =
        PrefUtils.getInt(StringConstants.isStudent);
    Timer(const Duration(seconds: 3), () {
      if (PrefUtils.getString(StringConstants.authToken).isNotEmpty) {
        Get.offAllNamed(AppRoutes.dashboardScreenRoute);
      } else {
        Get.offAllNamed(AppRoutes.loginScreenRoute);
      }
    });
    super.onInit();
  }
}
