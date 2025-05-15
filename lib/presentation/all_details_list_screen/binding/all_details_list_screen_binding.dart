import 'package:get/get.dart';
import 'package:pg_managment/presentation/all_details_list_screen/controller/all_details_list_screen_controller.dart';
import 'package:pg_managment/presentation/expense_list_screen/controller/expense_list_screen_controller.dart';

  class AllDetailsListScreenBinding extends Bindings {
  @override
  void dependencies() {   
    Get.lazyPut(() => AllDetailsListScreenController());
  }
}
