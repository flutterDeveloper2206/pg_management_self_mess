import 'package:pg_managment/presentation/monthly_transaction_screen/controller/monthly_transaction_screen_controller.dart';
import 'package:get/get.dart';

class MonthlyTransactionScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MonthlyTransactionScreenController());
  }
}
