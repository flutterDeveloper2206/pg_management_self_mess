import 'package:pg_managment/presentation/login_screen/controller/login_screen_controller.dart';
import 'package:get/get.dart';

class LoginScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginScreenController());
  }
}
