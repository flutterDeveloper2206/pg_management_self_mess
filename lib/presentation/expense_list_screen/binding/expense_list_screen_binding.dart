import 'package:get/get.dart';
import 'package:pg_managment/presentation/expense_list_screen/controller/expense_list_screen_controller.dart';

  class ExpenseListScreenBinding extends Bindings {
  @override
  void dependencies() {   
    Get.lazyPut(() => ExpenseListScreenController());
  }
}
