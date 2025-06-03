import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pg_managment/ApiServices/api_service.dart';
import 'package:pg_managment/core/utils/app_network_urls.dart';
import 'package:pg_managment/core/utils/navigation_service.dart';
import 'package:pg_managment/core/utils/progress_dialog_utils.dart';
import 'package:pg_managment/presentation/expense_list_screen/expense_list_model.dart';

class AddExpenseScreenController extends GetxController {
  TextEditingController itemController = TextEditingController();
  TextEditingController dateController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    TextEditingController remarkController = TextEditingController();

  dynamic argumentData = Get.arguments;

  RxInt isAddEdit = 0.obs;

  RxBool readOnly = false.obs;
  RxBool isLoading = false.obs;

  Rx<Data> model = Data().obs;

  @override
  void onInit() {
    if (argumentData != null) {
      isAddEdit.value = argumentData['isAddEdit'];
      model.value = argumentData['data'];

      if (isAddEdit.value == 2) {
        readOnly.value = true;
      }
    }
    setData();
    super.onInit();
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

  setData() {
    itemController.text = model.value.item ?? '';

    dateController.text =
        '${DateFormat("yyyy-MM-dd").format(model?.value.date ?? DateTime.now())}';

    amountController.text = '${model.value.amount ?? ''}';
    remarkController.text = model.value.remark ?? '';
  }

  Future<void> addExpense({String? id}) async {
    isLoading.value = true;
    if (itemController.text.isEmpty) {
      AppFlushBars.appCommonFlushBar(
          context: NavigationService.navigatorKey.currentContext!,
          message: 'Please enter item',
          success: false);
      isLoading.value = false;
      return;
    } else if (amountController.text.isEmpty) {
      AppFlushBars.appCommonFlushBar(
          context: NavigationService.navigatorKey.currentContext!,
          message: 'Please enter amount',
          success: false);
      isLoading.value = false;
      return;
    } else if (dateController.text.isEmpty) {
      AppFlushBars.appCommonFlushBar(
          context: NavigationService.navigatorKey.currentContext!,
          message: 'Please enter date',
          success: false);
      isLoading.value = false;
      return;
    } else {
      isLoading.value = false;
      if (isAddEdit.value == 1) {
        await ApiService().callPutApi(
            body: {
              'item': itemController.text,
              'amount': amountController.text,
              'date': dateController.text,
              'remark': remarkController.text,
            },
            headerWithToken: true,
            showLoader: true,
            url: isAddEdit.value == 1
                ? NetworkUrls.expenseUpdateUrl + model.value.id.toString()
                : NetworkUrls.expenseAddUrl).then((value) async {
          if (value != null &&
              (value.statusCode == 200 || value.statusCode == 201)) {
            if (isAddEdit.value == 1) {
              Get.back();

            }else{

            }

            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              AppFlushBars.appCommonFlushBar(
                  context: NavigationService.navigatorKey.currentContext!,
                  message: isAddEdit.value == 0
                      ? 'Expense Added successfully'
                      : 'Expense Updated successfully',
                  success: true);
            });
          }
        });
      } else {
        await ApiService().callPostApi(
            body: {
              'item': itemController.text,
              'amount': amountController.text,
              'date': dateController.text,
              'remark': remarkController.text,
            },
            headerWithToken: true,
            showLoader: true,
            url: isAddEdit.value == 1
                ? NetworkUrls.expenseUpdateUrl + model.value.id.toString()
                : NetworkUrls.expenseAddUrl).then((value) async {
          if (value != null &&
              (value.statusCode == 200 || value.statusCode == 201)) {
            if (isAddEdit.value == 1) {
              Get.back();

            }else{
              itemController.clear();
          amountController.clear();
          remarkController.clear();
            }

            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              AppFlushBars.appCommonFlushBar(
                  context: NavigationService.navigatorKey.currentContext!,
                  message: isAddEdit.value == 0
                      ? 'Expense Added successfully'
                      : 'Expense Updated successfully',
                  success: true);
            });
          }
        });
      }
    }
  }
}
