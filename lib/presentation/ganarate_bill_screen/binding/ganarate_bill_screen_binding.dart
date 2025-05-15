import 'package:pg_managment/presentation/ganarate_bill_screen/controller/ganarate_bill_screen_controller.dart';
import 'package:get/get.dart';

class GanarateBillScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GanarateBillScreenController());
  }
}
