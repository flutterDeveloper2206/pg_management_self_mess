import 'dart:developer';
import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';
import 'package:get/get_connect/connect.dart';
import 'package:pg_managment/core/utils/common_function.dart';
import 'package:pg_managment/core/utils/navigation_service.dart';
import 'package:pg_managment/core/utils/pref_utils.dart';
import 'package:pg_managment/core/utils/progress_dialog_utils.dart';
import 'package:pg_managment/core/utils/string_constant.dart';
import 'package:pg_managment/routes/app_routes.dart';
import 'network_info.dart';

class ApiService extends GetConnect {
  ApiService() {
    timeout = const Duration(seconds: 120);
  }
  var headers;
  var headersWithToken;
  var contentType;
  String authToken = '';

  Future<void> getToken() async {}

  Future<void> initApiService() async {
    await NetworkInfo.checkNetwork().whenComplete(() async {
      authToken = await PrefUtils.getString(StringConstants.authToken);
      print("Auth Token from API service is :- $authToken");
      headers = {"Accept": "application/json"};
      headersWithToken = {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken"
      };
      contentType = "application/json";
    });
  }

  Future<dynamic> callPostApi(
      {required body,
      required url,
      bool showLoader = true,
      bool headerWithToken = true}) async {
    try {
      if (showLoader) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          ProgressDialogUtils.showProgressDialog(isCancellable: false);
        });
      }
      await initApiService();
      if (isLogPrint) {
        log("API :- $url");
        log("BODY :- ${body}");
      }
      final response = await post(
        url,
        body,
        headers: headerWithToken ? headersWithToken : headers,
        contentType: contentType,
      );
      if (isLogPrint) {
        log("RESPONSE :- ${response.body}");
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (isLogPrint) {
          log("RESPONSE :- ${response.body}");
        }
        ProgressDialogUtils.hideProgressDialog();
        return response;
      } else {
        if (isLogPrint) {
          log("RESPONSE :- ${response.body}");
        }
        ProgressDialogUtils.hideProgressDialog();
        if (response.statusCode == 422) {
          AppFlushBars.appCommonFlushBar(
              context: NavigationService.navigatorKey.currentContext!,
              message: response.body['message'],
              success: false);
        } else if (response.body['state_code'] == 404 &&
            response.body['message'] == 'Unauthenticated') {
          AppFlushBars.appCommonFlushBar(
              context: NavigationService.navigatorKey.currentContext!,
              message: response.body['message'],
              success: false);
          Get.toNamed(AppRoutes.loginScreenRoute);
        } else if (response.body['state_code'] == 401) {
          AppFlushBars.appCommonFlushBar(
              context: NavigationService.navigatorKey.currentContext!,
              message: response.body['message'],
              success: false);
        } else if (response.body['state_code'] == 404) {
          AppFlushBars.appCommonFlushBar(
              context: NavigationService.navigatorKey.currentContext!,
              message: response.body['message'],
              success: false);
        } else if (response.body['state_code'] == 409) {
          AppFlushBars.appCommonFlushBar(
              context: NavigationService.navigatorKey.currentContext!,
              message: response.body['message'],
              success: false);
        } else {
          return response;
        }
      }
    } catch (e) {
      if (isLogPrint) {
        log("ERROR :- $e");
      }
      AppFlushBars.appCommonFlushBar(
          context: NavigationService.navigatorKey.currentState!.context,
          message: 'Something went wrong',
          success: false);
    }
  }

  Future<dynamic> callPutApi(
      {required body,
      required url,
      bool showLoader = true,
      bool headerWithToken = true}) async {
    try {
      if (showLoader) {
        ProgressDialogUtils.showProgressDialog(isCancellable: false);
      }
      await initApiService();
      if (isLogPrint) {
        log("API :- $url");
        log("BODY :- ${body}");
      }
      final response = await put(
        url,
        body,
        headers: headerWithToken ? headersWithToken : headers,
        contentType: contentType,
      );
      if (isLogPrint) {
        log("RESPONSE :- ${response.body}");
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (isLogPrint) {
          log("RESPONSE :- ${response.body}");
        }
        ProgressDialogUtils.hideProgressDialog();
        return response;
      } else {
        if (isLogPrint) {
          log("RESPONSE :- ${response.body}");
        }
        ProgressDialogUtils.hideProgressDialog();
        if (response.statusCode == 422) {
          AppFlushBars.appCommonFlushBar(
              context: NavigationService.navigatorKey.currentContext!,
              message: response.body['message'],
              success: false);
        } else if (response.body['state_code'] == 404 &&
            response.body['message'] == 'Unauthenticated') {
          AppFlushBars.appCommonFlushBar(
              context: NavigationService.navigatorKey.currentContext!,
              message: response.body['message'],
              success: false);
          Get.toNamed(AppRoutes.loginScreenRoute);
        } else if (response.body['state_code'] == 401) {
          AppFlushBars.appCommonFlushBar(
              context: NavigationService.navigatorKey.currentContext!,
              message: response.body['message'],
              success: false);
        } else if (response.body['state_code'] == 404) {
          AppFlushBars.appCommonFlushBar(
              context: NavigationService.navigatorKey.currentContext!,
              message: response.body['message'],
              success: false);
        } else {
          return response;
        }
      }
    } catch (e) {
      if (isLogPrint) {
        log("ERROR :- $e");
      }
      AppFlushBars.appCommonFlushBar(
          context: NavigationService.navigatorKey.currentContext!,
          message: 'Something went wrong',
          success: false);
    }
  }

  Future<dynamic> callGetApi(
      {required dynamic body,
      required url,
      bool showLoader = true,
      bool headerWithToken = true}) async {
    try {
      if (isLogPrint) {
        log("API :- $url");
        log("API :- ${isLogPrint.toString()}");
      }

      if (showLoader) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
      }
      await initApiService();

      final response = await get(
        url,
        headers: headerWithToken ? headersWithToken : headers,
        contentType: contentType,
      );
      if (isLogPrint) {
        log("RESPONSE :- ${response.body}");
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (isLogPrint) {
          log("RESPONSE :- ${response.body}");
        }
        ProgressDialogUtils.hideProgressDialog();
        return response;
      } else {
        if (isLogPrint) {
          log("RESPONSE :- ${response.body}");
        }
        ProgressDialogUtils.hideProgressDialog();
        if (response.statusCode == 422) {
          AppFlushBars.appCommonFlushBar(
              context: NavigationService.navigatorKey.currentContext!,
              message: response.body['message'],
              success: false);
        } else if (response.body['state_code'] == 404 &&
            response.body['message'] == 'Unauthenticated') {
          AppFlushBars.appCommonFlushBar(
              context: NavigationService.navigatorKey.currentContext!,
              message: response.body['message'],
              success: false);
          Get.toNamed(AppRoutes.loginScreenRoute);
        } else if (response.statusCode == 401) {
          AppFlushBars.appCommonFlushBar(
              context: NavigationService.navigatorKey.currentContext!,
              message: response.body['message'],
              success: false);
        } else if (response.body['state_code'] == 404) {
          AppFlushBars.appCommonFlushBar(
              context: NavigationService.navigatorKey.currentContext!,
              message: response.body['message'],
              success: false);
        } else {
          return response;
        }
      }
    } catch (e) {
      if (isLogPrint) {
        log("ERROR :- $e");
      }
      AppFlushBars.appCommonFlushBar(
          context: NavigationService.navigatorKey.currentContext!,
          message: 'Something went wrong',
          success: false);
    }

    //  if (response.status.hasError) {
    //   if (showLoader) {
    //     ProgressDialogUtils.hideProgressDialog();
    //   }
    //   return response;
    // } else {
    //   if (showLoader) {
    //     ProgressDialogUtils.hideProgressDialog();
    //   }
    //   return response;
    // }
  }

  Future<dynamic> callDeleteApi(
      {required dynamic body,
      required url,
      bool showLoader = true,
      bool headerWithToken = true}) async {
    try {
      if (isLogPrint) {
        log("API :- $url");
        log("API :- ${isLogPrint.toString()}");
      }

      if (showLoader) {
        ProgressDialogUtils.showProgressDialog(isCancellable: false);
      }
      await initApiService();

      final response = await delete(
        url,
        headers: headerWithToken ? headersWithToken : headers,
        contentType: contentType,
      );
      if (isLogPrint) {
        log("RESPONSE :- ${response.body}");
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (isLogPrint) {
          log("RESPONSE :- ${response.body}");
        }
        ProgressDialogUtils.hideProgressDialog();
        return response;
      } else {
        if (isLogPrint) {
          log("RESPONSE :- ${response.body}");
        }
        ProgressDialogUtils.hideProgressDialog();
        if (response.statusCode == 422) {
          AppFlushBars.appCommonFlushBar(
              context: NavigationService.navigatorKey.currentContext!,
              message: response.body['message'],
              success: false);
        } else if (response.body['state_code'] == 404 &&
            response.body['message'] == 'Unauthenticated') {
          AppFlushBars.appCommonFlushBar(
              context: NavigationService.navigatorKey.currentContext!,
              message: response.body['message'],
              success: false);
          Get.toNamed(AppRoutes.loginScreenRoute);
        } else if (response.statusCode == 401) {
          AppFlushBars.appCommonFlushBar(
              context: NavigationService.navigatorKey.currentContext!,
              message: response.body['message'],
              success: false);
        } else if (response.body['state_code'] == 404) {
          AppFlushBars.appCommonFlushBar(
              context: NavigationService.navigatorKey.currentContext!,
              message: response.body['message'],
              success: false);
        } else {
          return response;
        }
      }
    } catch (e) {
      if (isLogPrint) {
        log("ERROR :- $e");
      }
      AppFlushBars.appCommonFlushBar(
          context: NavigationService.navigatorKey.currentContext!,
          message: 'Something went wrong',
          success: false);
    }

    //  if (response.status.hasError) {
    //   if (showLoader) {
    //     ProgressDialogUtils.hideProgressDialog();
    //   }
    //   return response;
    // } else {
    //   if (showLoader) {
    //     ProgressDialogUtils.hideProgressDialog();
    //   }
    //   return response;
    // }
  }

  Future<FormData> getBlankApiBody() async {
    final form = FormData({});
    return form;
  }
}
