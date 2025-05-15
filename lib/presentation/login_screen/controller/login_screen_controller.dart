import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pg_managment/ApiServices/api_service.dart';
import 'package:pg_managment/core/utils/app_network_urls.dart';
import 'package:pg_managment/core/utils/commonConstant.dart';
import 'package:pg_managment/core/utils/navigation_service.dart';
import 'package:pg_managment/core/utils/pref_utils.dart';
import 'package:pg_managment/core/utils/progress_dialog_utils.dart';
import 'package:pg_managment/core/utils/string_constant.dart';
import 'package:pg_managment/presentation/login_screen/model/login_model.dart';
import 'package:pg_managment/routes/app_routes.dart';

class LoginScreenController extends GetxController {
  RxBool isShow = false.obs;
  RxBool isLoading = false.obs;

  Rx<LoginModel> loginModel = LoginModel().obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future login(String email, String password) async {
    isLoading.value = true;

    if (email.isEmpty) {
      return AppFlushBars.appCommonFlushBar(
          context: NavigationService.navigatorKey.currentContext!,
          message: 'Please enter Your Email',
          success: false);
    }

    // if (!RegExp(
    //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    //     .hasMatch(email)) {
    //   return AppFlushBars.appCommonFlushBar(
    //       context: NavigationService.navigatorKey.currentContext!,
    //       message: 'Please enter a valid email',
    //       success: false);
    // }

    if (password.isEmpty) {
      return AppFlushBars.appCommonFlushBar(
          context: NavigationService.navigatorKey.currentContext!,
          message: 'Please enter Your Password',
          success: false);
    }

    await ApiService().callPostApi(
        body: {
          'email': email,
          'password': password,
        },
        headerWithToken: false,
        showLoader: true,
        url: NetworkUrls.loginUrl).then((value) async {
      isLoading.value = false;
      if (value != null && value.statusCode == 200) {
        loginModel.value = LoginModel.fromJson(value.body);
        PrefUtils.setString(StringConstants.authToken,
            loginModel.value.data?.accessToken ?? '');
        if (loginModel.value.data?.user?.studentId!=null) {

          CommonConstant.instance.isStudent=true;
          PrefUtils.setString(StringConstants.studentId,
              '${loginModel.value.data?.user?.studentId ?? ' '}');
          PrefUtils.setBool(StringConstants.isStudent,
             true);
        }else{
          CommonConstant.instance.isStudent=false;
          PrefUtils.setBool(StringConstants.isStudent,
              false);
        }

        Get.toNamed(AppRoutes.dashboardScreenRoute);
      }
    });
  }
}
