import 'dart:async';

import 'package:get/get.dart';
import 'package:pg_managment/routes/app_routes.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    Timer(const Duration(seconds: 3),
        () => Get.toNamed(AppRoutes.loginScreenRoute));
    super.onInit();
  }

}
