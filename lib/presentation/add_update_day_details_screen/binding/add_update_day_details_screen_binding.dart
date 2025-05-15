import 'package:pg_managment/presentation/_screen/controller/_screen_controller.dart';
import 'package:get/get.dart';
import 'package:pg_managment/presentation/add_update_day_details_screen/controller/add_update_day_details_screen_controller.dart';

  class AddUpdateDayDetailsScreenBinding extends Bindings {
  @override
  void dependencies() {   
    Get.lazyPut(() => AddUpdateDayDetailsScreenController());
  }
}
