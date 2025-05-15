import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pg_managment/ApiServices/api_service.dart';
import 'package:pg_managment/core/utils/app_network_urls.dart';
import 'package:pg_managment/core/utils/navigation_service.dart';
import 'package:pg_managment/core/utils/progress_dialog_utils.dart';
import 'package:pg_managment/presentation/monthly_transaction_screen/transaction_model.dart';

class MonthlyTransactionScreenController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<MonthlyTransactionModel> monthlyTransactionList =
      MonthlyTransactionModel().obs;

  TextEditingController yearController = TextEditingController();
  TextEditingController monthController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    yearController.text = DateTime.now().year.toString();
    monthController.text = DateTime.now().month.toString();
    getMonthlyTransaction();
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
      monthController.text = formattedDate;
    }
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
      yearController.text = formattedDate;
    }
  }

  Future<void> getMonthlyTransaction() async {
    if (yearController.text.isEmpty || monthController.text.isEmpty) {
      AppFlushBars.appCommonFlushBar(
          context: NavigationService.navigatorKey.currentContext!,
          message: 'Please enter both year and month',
          success: false);
      return;
    }
    isLoading.value = true;

    await ApiService().callPostApi(
        body: {"year": yearController.text, "month": monthController.text},
        url: NetworkUrls.monthlyTransactionUrl,
        headerWithToken: true,
        showLoader: false).then((value) async {
      isLoading.value = false;
      if (value != null && value.statusCode == 200) {
        monthlyTransactionList.value =
            MonthlyTransactionModel.fromJson(value.body);
        isLoading.value = false;
      } else {
        isLoading.value = false;
        monthlyTransactionList.value = MonthlyTransactionModel();
      }
    });
  }
}
