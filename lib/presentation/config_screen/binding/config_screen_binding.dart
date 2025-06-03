import 'package:get/get.dart';

import '../controller/config_screen_controller.dart';

  class ConfigScreenBinding extends Bindings {
  @override
  void dependencies() {   
    Get.lazyPut(() => ConfigScreenController());
  }
}
