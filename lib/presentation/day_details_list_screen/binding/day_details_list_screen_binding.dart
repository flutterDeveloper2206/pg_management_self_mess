import 'package:get/get.dart';
import 'package:pg_managment/presentation/all_details_list_screen/controller/all_details_list_screen_controller.dart';
import 'package:pg_managment/presentation/day_details_list_screen/controller/day_details_list_screen_controller.dart';
import 'package:pg_managment/presentation/expense_list_screen/controller/expense_list_screen_controller.dart';

  class DayDetailsListScreenBinding extends Bindings {
  @override
  void dependencies() {   
    Get.lazyPut(() => DayDetailsListScreenController());
  }
}
