import 'package:pg_managment/presentation/_screen/controller/_screen_controller.dart';
import 'package:get/get.dart';

import '../controller/deposit_details_screen_controller.dart';

  class DepositDetailsScreenBinding extends Bindings {
  @override
  void dependencies() {   
    Get.lazyPut(() => DepositDetailsScreenController());
  }
}
