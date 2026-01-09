import 'package:get/get.dart';
import '../controller/menu_screen_controller.dart';

class MenuScreenBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut(() => MenuScreenController());
  }
}
