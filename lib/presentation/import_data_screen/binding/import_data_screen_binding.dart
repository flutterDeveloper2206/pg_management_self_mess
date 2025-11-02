import 'package:get/get.dart';

import '../controller/import_data_screen_controller.dart';

  class ImportDataScreenBinding extends Bindings {
  @override
  void dependencies() {   
    Get.lazyPut(() => ImportDataScreenController());
  }
}
