import 'package:pg_managment/presentation/dashboard_screen/controller/dashboard_screen_controller.dart';
import 'package:get/get.dart';

  class DashboardScreenBinding extends Bindings {
  @override
  void dependencies() {   
    Get.lazyPut(() => DashboardScreenController());
  }
}
