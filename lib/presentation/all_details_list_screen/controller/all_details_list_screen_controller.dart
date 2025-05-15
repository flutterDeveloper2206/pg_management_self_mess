import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pg_managment/core/utils/app_network_urls.dart';
import 'package:pg_managment/core/utils/navigation_service.dart';
import 'package:pg_managment/core/utils/progress_dialog_utils.dart';
import 'package:pg_managment/presentation/all_details_list_screen/all_details_list_model.dart';

import '../../../ApiServices/api_service.dart';

class AllDetailsListScreenController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<StudentAllDetailsModel> allStudentListModel = StudentAllDetailsModel().obs;
  TextEditingController month = TextEditingController();
  TextEditingController year = TextEditingController();

  @override
  void onInit() {
    month.text = DateTime.now().month.toString().padLeft(2, '0');
    year.text = DateTime.now().year.toString();
    getAllStudentDetails(month: month.text, year: year.text);
    super.onInit();
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

  Future<void> getAllStudentDetails({String? month, String? year}) async {
    isLoading.value = true;

    await ApiService().callGetApi(
        body: {},
        headerWithToken: true,
        showLoader: false,
        url:
            '${NetworkUrls.dayDetailsListUrl}month=$month&year=$year').then(
        (value) async {
      isLoading.value = false;
      if (value != null && value.statusCode == 200) {
        isLoading.value = false;
        allStudentListModel.value = StudentAllDetailsModel.fromJson(value.body);
      }
    });
  }

  Future<void> getNotificationApi() async {
    isLoading.value = true;

    try {
      await ApiService()
          .callGetApi(
              body: FormData({}),
              headerWithToken: false,
              showLoader: true,
              url: '')
          .then((value) async {
        if (value.statusCode == 200) {
          isLoading.value = false;
          allStudentListModel.value =
              StudentAllDetailsModel.fromJson(value.body);
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

      AppFlushBars.appCommonFlushBar(
          context: NavigationService.navigatorKey.currentContext!,
          message: 'Something went wrong',
          success: false);
    }
  }
}
