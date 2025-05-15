import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pg_managment/ApiServices/api_service.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/app_network_urls.dart';
import 'package:pg_managment/core/utils/navigation_service.dart';
import 'package:pg_managment/core/utils/progress_dialog_utils.dart';

class GanarateBillScreenController extends GetxController {
  Rx<TextEditingController> rateController = TextEditingController().obs;
  Rx<TextEditingController> guestCashController = TextEditingController().obs;
RxString billTotal = '0.0'.obs;
  RxBool isLoading = false.obs;
  RxBool isLock = false.obs;

  @override
  void onInit() {
    super.onInit();
    calculateRate();
  }

  Future<void> calculateRate() async {
    await ApiService().callGetApi(
        body: {},
        headerWithToken: true,
        showLoader: true,
        url: NetworkUrls.calculateRateUrl).then((value) async {
      if (value != null && value.statusCode == 200) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          rateController.value.text = value.body['data']['rate'].toString();
          billTotal.value = value.body['data']['total'].toString();
          isLock.value = value.body['data']['status'] == 'lock';
        });
        update();
      }
    });
  }

  Future<void> generateBill(bool isLock) async {
    isLoading.value = true;
    await ApiService().callPostApi(
        body: {
          'rate': rateController.value.text,
          'guest_cash': guestCashController.value.text,
          "status": isLock ? "lock" : "generated"
        },
        headerWithToken: true,
        showLoader: true,
        url: NetworkUrls.generateBillUrl).then((value) async {
      isLoading.value = false;
      if (value != null && value.statusCode == 200) {
        isLoading.value = false;

        Get.back();
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          AppFlushBars.appCommonFlushBar(
              context: NavigationService.navigatorKey.currentContext!,
              message: "Bill generated successfully",
              success: true);
        });
      }
    });
  }
}
