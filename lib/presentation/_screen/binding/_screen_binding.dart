import 'package:pg_managment/presentation/_screen/controller/_screen_controller.dart';
import 'package:get/get.dart';

  class ScreenBinding extends Bindings {
  @override
  void dependencies() {   
    Get.lazyPut(() => ScreenController());
  }
}
