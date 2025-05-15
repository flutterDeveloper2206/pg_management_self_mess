import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pg_managment/core/utils/app_network_urls.dart';
import 'package:pg_managment/core/utils/navigation_service.dart';
import 'package:pg_managment/core/utils/progress_dialog_utils.dart';
import 'package:pg_managment/core/utils/progress_dialog_utils.dart';
import 'package:pg_managment/presentation/all_details_list_screen/all_details_list_model.dart';
import 'package:pg_managment/presentation/expense_list_screen/expense_list_model.dart';
import 'package:pg_managment/presentation/student_list_screen/student_list_model.dart';

import '../../../ApiServices/api_service.dart';

class AddUpdateDayDetailsScreenController extends GetxController {
  RxBool isLoading = false.obs;

  Rx<StudentAllDetailsModel> allStudentListModel = StudentAllDetailsModel().obs;
  RxInt studentId = 0.obs;
  RxInt isAdd = 0.obs;
  RxString studentName = ''.obs;
  RxBool readOnly = false.obs;
  Rx<AllData> dataGet = AllData().obs;

  var argument = Get.arguments;

  TextEditingController totalDayController = TextEditingController();
  TextEditingController totalEatDayController = TextEditingController();
  TextEditingController cutDayController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController simpleGuestController = TextEditingController();
  TextEditingController simpleGuestAmountController = TextEditingController();
  TextEditingController feastGuestController = TextEditingController();
  TextEditingController feastGuestAmountController = TextEditingController();
  TextEditingController penaltyAmountController = TextEditingController();
  TextEditingController paidAmountController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  @override
  void onInit() {
    if (argument != null) {
      studentId.value = argument['student_id'];
      studentName.value = argument['name'];
      isAdd.value = argument['isAdd'];
      if (argument['data'] != null) {
        dataGet.value = argument['data'];
        setData();
      }

      if (isAdd.value == 2) {
        readOnly.value = true;
      }
    }
    super.onInit();
  }

  setData() {
    totalDayController.text = dataGet.value.totalDay.toString();
    totalEatDayController.text = dataGet.value.totalEatDay.toString();
    cutDayController.text = dataGet.value.cutDay.toString();
    dateController.text =
        DateFormat("yyyy-MM-dd").format(dataGet.value.date ?? DateTime.now());
    simpleGuestController.text = dataGet.value.simpleGuest.toString();
    simpleGuestAmountController.text =
        dataGet.value.simpleGuestAmount.toString();
    feastGuestController.text = dataGet.value.feastGuest.toString();
    feastGuestAmountController.text = dataGet.value.feastGuestAmount.toString();
    penaltyAmountController.text = dataGet.value.penaltyAmount.toString();
    paidAmountController.text = dataGet.value.paidAmount.toString();
    remarkController.text = dataGet.value.remark ?? '';
  }

  Future<void> selectDate(BuildContext context) async {
    print('object');
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2090),
    );

    if (picked != null) {
      String formattedDate =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      dateController.text = formattedDate;
    }
  }

  Future updateAddStudentDetails({String? id}) async {
    if (totalDayController.text.isEmpty ||
        totalEatDayController.text.isEmpty ||
        cutDayController.text.isEmpty ||
        dateController.text.isEmpty ||
        simpleGuestController.text.isEmpty ||
        simpleGuestAmountController.text.isEmpty ||
        feastGuestController.text.isEmpty ||
        feastGuestAmountController.text.isEmpty ||
        remarkController.text.isEmpty) {
      AppFlushBars.appCommonFlushBar(
          context: NavigationService.navigatorKey.currentContext!,
          message: 'Please fill all the fields',
          success: false);
      return;
    }

    if (isAdd.value == 0) {
      await ApiService().callPostApi(
          body: {
            "student_id": studentId.value,
            "total_day": int.parse(totalDayController.text),
            "total_eat_day": int.parse(totalEatDayController.text),
            "cut_day": int.parse(cutDayController.text),
            "date": dateController.text,
            "simple_guest": int.parse(simpleGuestController.text),
            "simple_guest_amount": int.parse(simpleGuestAmountController.text),
            "feast_guest": int.parse(feastGuestController.text),
            "paid_amount": int.parse(paidAmountController.text),
            "penalty_amount": int.parse(penaltyAmountController.text),
            "feast_guest_amount": int.parse(feastGuestAmountController.text),
            "remark": remarkController.text
          },
          headerWithToken: true,
          showLoader: true,
          url: NetworkUrls.dayDetailsAddUrl).then((value) async {
        if (value != null &&
            (value.statusCode == 200 || value.statusCode == 201)) {
          Get.back();

          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            AppFlushBars.appCommonFlushBar(
                context: NavigationService.navigatorKey.currentContext!,
                message: 'Student details added successfully',
                success: true);
          });
        }
      });
    } else {
      await ApiService().callPutApi(
          body: {
            "student_id": studentId.value,
            "total_day": int.parse(totalDayController.text),
            "total_eat_day": int.parse(totalEatDayController.text),
            "cut_day": int.parse(cutDayController.text),
            "date": dateController.text,
            "simple_guest": int.parse(simpleGuestController.text),
            "simple_guest_amount": int.parse(simpleGuestAmountController.text),
            "feast_guest": int.parse(feastGuestController.text),
            "feast_guest_amount": int.parse(feastGuestAmountController.text),
            "remark": remarkController.text
          },
          headerWithToken: true,
          showLoader: true,
          url: NetworkUrls.dayDetailsUpdateUrl + id!).then((value) async {
        if (value != null &&
            (value.statusCode == 200 || value.statusCode == 201)) {
          Get.back();

          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            AppFlushBars.appCommonFlushBar(
                context: NavigationService.navigatorKey.currentContext!,
                message: 'Student detailsupdated successfully',
                success: true);
          });
        }
      });
    }
  }
}
