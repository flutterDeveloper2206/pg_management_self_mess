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
  TextEditingController month = TextEditingController();
  TextEditingController year = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    DateTime now = DateTime.now();
    DateTime picked = DateTime(now.year, now.month, 0);
    month.text= picked.month.toString();
    year.text= picked.year.toString();
    calculateRate();
  }
  Future<void> selectYear(BuildContext context) async {
    print('object');
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDatePickerMode: DatePickerMode.year,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2090),
    );

    if (picked != null) {
      String formattedDate = "${picked.year.toString()}";
      year.text = formattedDate;
    }
  }
  Future<void> selectMonth(BuildContext context) async {
    print('object');
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDatePickerMode: DatePickerMode.day,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2090),
    );

    if (picked != null) {
      String formattedDate = picked.month.toString().padLeft(2, '0');
      month.text = formattedDate;
    }
  }

  Future<void> calculateRate() async {

    await ApiService().callGetApi(
        body: {},
        headerWithToken: true,
        showLoader: true,
        url: '${NetworkUrls.calculateRateUrl}?month=${month.text}&year=${year.text}').then((value) async {
      if (value != null && value.statusCode == 200) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          rateController.value.text = value.body['data']['rate'].toString();
          billTotal.value = value.body['data']['total'].toString();
          isLock.value = value.body['data']['status'] == 'lock';
        });
        update();
      }else{
        rateController.value.clear();
        billTotal.value='0.0';
      }
    });
  }

  Future<void> generateBill(bool isLock) async {
    isLoading.value = true;
    await ApiService().callPostApi(
        body: {
          'month':int.parse(month.text),
          'year':int.parse(year.text),
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
