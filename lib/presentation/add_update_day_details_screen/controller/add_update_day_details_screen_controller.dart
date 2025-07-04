import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pg_managment/core/utils/app_network_urls.dart';
import 'package:pg_managment/core/utils/navigation_service.dart';
import 'package:pg_managment/core/utils/pref_utils.dart';
import 'package:pg_managment/core/utils/progress_dialog_utils.dart';
import 'package:pg_managment/core/utils/progress_dialog_utils.dart';
import 'package:pg_managment/core/utils/string_constant.dart';
import 'package:pg_managment/presentation/all_details_list_screen/all_details_list_model.dart';
import 'package:pg_managment/presentation/expense_list_screen/expense_list_model.dart';
import 'package:pg_managment/presentation/student_list_screen/student_list_model.dart';

import '../../../ApiServices/api_service.dart';

class AddUpdateDayDetailsScreenController extends GetxController {
  RxBool isLoading = false.obs;

  Rx<StudentAllDetailsModel> allStudentListModel = StudentAllDetailsModel().obs;
  RxInt studentId = 0.obs;
  RxDouble totalDay = 0.0.obs;
  RxDouble penalty = 0.0.obs;
  RxDouble eatenDay = 0.0.obs;
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
  TextEditingController remainController = TextEditingController();

  @override
  void onInit() {
    if (argument != null) {
      studentId.value = argument['student_id'];
      studentName.value = argument['name'];
      isAdd.value = argument['isAdd'];
      if (argument['data'] != null) {
        dataGet.value = argument['data'];
        setData();
        setRemainAmountCalculate();
      }

      if (isAdd.value == 2) {
        readOnly.value = true;
      }
      if (isAdd.value == 0) {
        setDate();

        String day = PrefUtils.getString(StringConstants.totalDays).isEmpty
            ? '0.0'
            : PrefUtils.getString(StringConstants.totalDays);
        String eatenDays = PrefUtils.getString(StringConstants.eatenDays).isEmpty
            ? '0.0'
            : PrefUtils.getString(StringConstants.eatenDays);
       String penaltyS = PrefUtils.getString(StringConstants.penalty).isEmpty
            ? '0.0'
            : PrefUtils.getString(StringConstants.penalty);

        totalDay.value = double.parse(day);
        penalty.value = double.parse(penaltyS);
        eatenDay.value = double.parse(eatenDays);
        totalDayController.text = totalDay.value.toInt().toString();
        penaltyAmountController.text = penalty.value.toInt().toString();
        totalEatDayController.text = eatenDay.value.toInt().toString();
        simpleGuestController.text = '0';
        feastGuestController.text = '0';
        feastGuestAmountController.text = '0';
        simpleGuestAmountController.text = '0';
        changeEatDay(totalEatDayController.text);
      }
    }
    super.onInit();
  }


  setDate(){
    DateTime now = DateTime.now();
    DateTime picked = DateTime(now.year, now.month, 0);
    String formattedDate =
        "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    dateController.text = formattedDate;
    paidAmountController.text='0.0';
    print(picked); // Example output: 2025-05-31 00:00:00.000
  }
  changeEatDay(String value) {
    if (value.isNotEmpty) {
      int val = int.parse(value);
      cutDayController.text = (totalDay.value.toInt() - val).toString();
    }else{
      cutDayController.clear();
    }
  }
  changeFeastAndSimple(String value, bool isSimpleOrFeast) {
    if (value.isEmpty) {
      if(isSimpleOrFeast){
        simpleGuestAmountController.text='0';
        simpleGuestController.text='0';
      }else{
        feastGuestAmountController.text='0';
        feastGuestController.text='0';
      }
    }
  }

  changeCutDay(String value) {
    if (value.isNotEmpty) {
      int val = int.parse(value);
      totalEatDayController.text = (totalDay.value.toInt() - val).toString();
    }else{
      totalEatDayController.clear();
    }
  }

  calculateSimpleGuestAmount( String value){
    if(value.isNotEmpty) {
      String amount = PrefUtils.getString(StringConstants.simpleGuest).isEmpty
        ? '0.0'
        : PrefUtils.getString(StringConstants.simpleGuest);
    simpleGuestAmountController.text = (int.parse(value) * double.parse(amount)).toString();
    }else{
      simpleGuestAmountController.clear();
    }

  }calculateFeastGuestAmount( String value){
    if(value.isNotEmpty) {
      String amount = PrefUtils.getString(StringConstants.feastGuest).isEmpty
        ? '0.0'
        : PrefUtils.getString(StringConstants.feastGuest);
    feastGuestAmountController.text = (int.parse(value) * double.parse(amount)).toString();
    }else{
      feastGuestAmountController.clear();
    }

  }

  setRemainAmountCalculate() {
    if (paidAmountController.text.isNotEmpty) {
      remainController.text = ((dataGet.value.totalAmount ?? 0) -
              double.parse(paidAmountController.text))
          .toString();
    } else {
      remainController.text = '0.0';
    }
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
        feastGuestAmountController.text.isEmpty ) {
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
            "simple_guest_amount":
                double.parse(simpleGuestAmountController.text),
            "feast_guest": int.parse(feastGuestController.text),
            "paid_amount": double.parse(paidAmountController.text),
            "penalty_amount": double.parse(penaltyAmountController.text),
            "feast_guest_amount": double.parse(feastGuestAmountController.text),
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
            "simple_guest_amount":
                double.parse(simpleGuestAmountController.text),
            "feast_guest": int.parse(feastGuestController.text),
            "paid_amount": double.parse(paidAmountController.text),
            "remain_amount": double.parse(remainController.text),
            "penalty_amount": double.parse(penaltyAmountController.text),
            "feast_guest_amount": double.parse(feastGuestAmountController.text),
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
                message: 'Student details updated successfully',
                success: true);
          });
        }
      });
    }
  }
}
