import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pg_managment/core/utils/app_network_urls.dart';
import 'package:pg_managment/core/utils/commonConstant.dart';
import 'package:pg_managment/core/utils/navigation_service.dart';
import 'package:pg_managment/core/utils/pref_utils.dart';
import 'package:pg_managment/core/utils/progress_dialog_utils.dart';
import 'package:pg_managment/core/utils/string_constant.dart';
import 'package:pg_managment/presentation/all_details_list_screen/all_details_list_model.dart';

import '../../../ApiServices/api_service.dart';

class DayDetailsListScreenController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<StudentAllDetailsModel> allStudentListModel = StudentAllDetailsModel().obs;
  RxInt studentId = 0.obs;
  RxString studentName = ''.obs;
  var argument = Get.arguments;

  TextEditingController month = TextEditingController();
  TextEditingController year = TextEditingController();

  @override
  void onInit() {
    if (argument != null) {
      studentId.value = argument['student_id'];
      studentName.value = argument['name'];
    }
    if(CommonConstant.instance.isStudent){
      studentId.value = int.parse(PrefUtils.getString(StringConstants.studentId));
    }
    month.text = DateTime.now().month.toString().padLeft(2, '0');
    year.text = DateTime.now().year.toString();
    getAllStudentDetails(
        month: '',
        year: year.text,
        studentId: studentId.value.toString());
    super.onInit();
  }

  Future<void> selectYear(BuildContext context) async {
    print('object');
    month.clear();
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

  Future<void> getAllStudentDetails(
      {String? month, String? year, String? studentId}) async {
    isLoading.value = true;

    await ApiService().callGetApi(
        body: {},
        headerWithToken: true,
        showLoader: false,
        url: month?.isEmpty == true
            ? '${NetworkUrls.dayDetailsListUrl}year=$year&student_id=$studentId'
            : '${NetworkUrls.dayDetailsListUrl}month=$month&year=$year&student_id=$studentId').then(
        (value) async {
      isLoading.value = false;
      if (value != null && value.statusCode == 200) {
        isLoading.value = false;
        allStudentListModel.value = StudentAllDetailsModel.fromJson(value.body);
      }
    });
  }

  deleteStudentDetails(String? studentId) async {
    isLoading.value = true;
    await ApiService().callDeleteApi(
        body: {},
        headerWithToken: true,
        showLoader: true,
        url: '${NetworkUrls.dayDetailsDeleteUrl}$studentId').then((value) {
      isLoading.value = false;
      if (value != null && value.statusCode == 200) {
        isLoading.value = false;
        AppFlushBars.appCommonFlushBar(
            context: NavigationService.navigatorKey.currentContext!,
            message: 'Student details deleted successfully',
            success: true);
        getAllStudentDetails(
            month: month.text,
            year: year.text,
            studentId: studentId.toString());
      }
    });
  }
}
