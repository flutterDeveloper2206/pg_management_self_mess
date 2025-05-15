import 'package:get/get.dart';
import 'package:pg_managment/presentation/add_expense_screen/controller/add_expense_screen_controller.dart';

  class AddExpenseScreenBinding extends Bindings {
  @override
  void dependencies() {   
    Get.lazyPut(() => AddExpenseScreenController());
  }
}
