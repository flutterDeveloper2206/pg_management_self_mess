import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pg_managment/ApiServices/api_service.dart';
import 'package:pg_managment/core/utils/app_network_urls.dart';
import 'package:pg_managment/core/utils/navigation_service.dart';
import 'package:pg_managment/core/utils/pref_utils.dart';
import 'package:pg_managment/core/utils/progress_dialog_utils.dart';
import 'package:pg_managment/core/utils/string_constant.dart';

class ConfigScreenController extends GetxController {
  TextEditingController totalDaysController = TextEditingController();
  TextEditingController eatenDaysController = TextEditingController();
  TextEditingController penaltyController = TextEditingController();
  TextEditingController simpleGuestAmountController = TextEditingController();
  TextEditingController feastGuestAmountController = TextEditingController();

  @override
  void onInit() {
    getAndSetData();
    super.onInit();
  }

  getAndSetData() {
    totalDaysController.text = PrefUtils.getString(StringConstants.totalDays);
    eatenDaysController.text = PrefUtils.getString(StringConstants.eatenDays);
    penaltyController.text = PrefUtils.getString(StringConstants.penalty);

    feastGuestAmountController.text =
        PrefUtils.getString(StringConstants.feastGuest);

    simpleGuestAmountController.text =
        PrefUtils.getString(StringConstants.simpleGuest);

    print(totalDaysController.text);
    print(feastGuestAmountController.text);
    print(simpleGuestAmountController.text);
  }

  save() {
    if (totalDaysController.text.isEmpty) {
      AppFlushBars.appCommonFlushBar(
          context: NavigationService.navigatorKey.currentContext!,
          message: 'Please Enter Total Days!',
          success: false);
    } else if (eatenDaysController.text.isEmpty) {
      AppFlushBars.appCommonFlushBar(
          context: NavigationService.navigatorKey.currentContext!,
          message: 'Please Enter Eaten Day!',
          success: false);
    }else if (penaltyController.text.isEmpty) {
      AppFlushBars.appCommonFlushBar(
          context: NavigationService.navigatorKey.currentContext!,
          message: 'Please Enter Penalty',
          success: false);
    } else if (simpleGuestAmountController.text.isEmpty) {
      AppFlushBars.appCommonFlushBar(
          context: NavigationService.navigatorKey.currentContext!,
          message: 'Please Enter Simple Guest Amount!',
          success: false);
    } else if (feastGuestAmountController.text.isEmpty) {
      AppFlushBars.appCommonFlushBar(
          context: NavigationService.navigatorKey.currentContext!,
          message: 'Please Enter Feast Guest Amount!',
          success: false);
    }else  {
      PrefUtils.setString(
          StringConstants.totalDays, totalDaysController.text ?? '');
      PrefUtils.setString(
          StringConstants.eatenDays, eatenDaysController.text ?? '');
      PrefUtils.setString(
          StringConstants.feastGuest, feastGuestAmountController.text ?? '');
      PrefUtils.setString(
          StringConstants.simpleGuest, simpleGuestAmountController.text ?? '');
    }
    editConfig(
        key: 'simple_guest', id: '1', value: simpleGuestAmountController.text);
    editConfig(
        key: 'feast_guest', id: '2', value: feastGuestAmountController.text);
    editConfig(key: 'total_day', id: '3', value: totalDaysController.text);
    editConfig(key: 'eaten_day', id: '4', value: eatenDaysController.text);
  }
}

Future editConfig(
    {required String key, required String value, required String id}) async {
  await ApiService().callPutApi(
      body: {
        'config_key': key,
        'config_value': value,
      },
      headerWithToken: true,
      showLoader: true,
      url: '${NetworkUrls.getConfigUrl}/$id').then((value) async {
    if (value != null && (value.statusCode == 200 || value.statusCode == 201)) {
      if (id == '4') {
        Get.back();
        AppFlushBars.appCommonFlushBar(
            context: NavigationService.navigatorKey.currentContext!,
            message: 'Config Update SuccessFully!',
            success: true);
      }
    }
  });
}
