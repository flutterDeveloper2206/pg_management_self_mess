import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pg_managment/core/utils/app_network_urls.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/commonConstant.dart';
import 'package:pg_managment/core/utils/navigation_service.dart';
import 'package:pg_managment/core/utils/pref_utils.dart';
import 'package:pg_managment/core/utils/progress_dialog_utils.dart';
import 'package:pg_managment/core/utils/string_constant.dart';
import 'package:pg_managment/presentation/all_details_list_screen/all_details_list_model.dart';

import '../../../ApiServices/api_service.dart';
import 'package:pg_managment/widgets/month_year_picker.dart';

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
    if(CommonConstant.instance.isStudent!=1&&CommonConstant.instance.isStudent!=2&&CommonConstant.instance.isStudent!=3){
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
    final DateTime? picked = await MonthYearPicker.show(context, initialDate: DateTime(int.parse(year.text), month.text.isEmpty?1:int.parse(month.text)));

    if (picked != null) {
      month.text = picked.month.toString().padLeft(2, '0');
      year.text = picked.year.toString();
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
            month: '',
            year: year.text,
            studentId: studentId.toString());
      }
    });
  }
  void showDeleteConfirmationDialog(BuildContext context, VoidCallback onYesPressed) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this Entry?"),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          actionsAlignment: MainAxisAlignment.end,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("No",style: TextStyle(color: Colors.black),),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onYesPressed(); // Callback for yes
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.primary,
              ),
              child: Text("Yes",style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
  }

}
