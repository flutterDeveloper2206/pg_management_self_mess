import 'package:get/get.dart';
import 'package:pg_managment/core/utils/app_network_urls.dart';
import 'package:pg_managment/core/utils/navigation_service.dart';
import 'package:pg_managment/core/utils/progress_dialog_utils.dart';
import 'package:pg_managment/presentation/expense_list_screen/expense_list_model.dart';

import '../../../ApiServices/api_service.dart';

class ExpenseListScreenController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<ExpenseListModel> expenseListModel = ExpenseListModel().obs;
RxDouble totalExpanse = 0.0.obs;
  @override
  void onInit() {
    getExpenseList(
        month: '${DateTime.now().month}', year: '${DateTime.now().year}');
    super.onInit();
  }

  getExpenseList({String? month, String? year}) async {
    isLoading.value = true;

    await ApiService().callGetApi(
        body: {},
        headerWithToken: true,
        showLoader: false,
        url:
            '${NetworkUrls.expenseListUrl}month=$month&year=$year').then(
        (value) async {
      isLoading.value = false;
      if (value != null && value.statusCode == 200) {
        expenseListModel.value = ExpenseListModel.fromJson(value.body);
        for (var expense in expenseListModel.value.data!) {
          totalExpanse.value += expense?.amount?? 0;

        }
      }
    });
  }

  Future<void> deleteExpense({String? id}) async {
    isLoading.value = true;

    await ApiService().callDeleteApi(
        body: {},
        headerWithToken: true,
        showLoader: false,
        url: NetworkUrls.expenseDeleteUrl + id.toString()).then((value) async {
      isLoading.value = false;

      if (value != null && value.statusCode == 200) {
        getExpenseList(
            month: '${DateTime.now().month}', year: '${DateTime.now().year}');
      }
    });
  }
}
