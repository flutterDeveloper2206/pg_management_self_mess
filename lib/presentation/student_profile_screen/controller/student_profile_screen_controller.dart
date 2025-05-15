

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pg_managment/ApiServices/api_service.dart';
import 'package:pg_managment/core/utils/app_network_urls.dart';
import 'package:pg_managment/core/utils/navigation_service.dart';
import 'package:pg_managment/core/utils/pref_utils.dart';
import 'package:pg_managment/core/utils/progress_dialog_utils.dart';
import 'package:pg_managment/core/utils/string_constant.dart';
import 'package:pg_managment/presentation/student_profile_screen/student_profile_model.dart';

class StudentProfileScreenController extends GetxController {

  Rx<StudentProfileModel> model = StudentProfileModel().obs;
  RxBool isLoading = false.obs;
@override
  void onInit() {
  getStudentProfile();
  super.onInit();
  }

  Future<void> getStudentProfile() async {
    isLoading.value = true;

    try {
      await ApiService()
          .callGetApi(
          body: FormData({}),
          headerWithToken: true,
          showLoader: true,
          url: '${NetworkUrls.studentProfile}${PrefUtils.getString(StringConstants.studentId)}')
          .then((value) async {
        if (value.statusCode == 200) {
          isLoading.value = false;
          model.value =
              StudentProfileModel.fromJson(value.body);
        } else {
          isLoading.value = false;

          AppFlushBars.appCommonFlushBar(
              context: NavigationService.navigatorKey.currentContext!,
              message: 'Something went wrong',
              success: false);
        }
      });
    } catch (error) {
      isLoading.value = false;
WidgetsBinding.instance.addPostFrameCallback((_) {
  AppFlushBars.appCommonFlushBar(
      context: NavigationService.navigatorKey.currentContext!,
      message: error.toString(),
      success: false);

});

    }
  }

}
