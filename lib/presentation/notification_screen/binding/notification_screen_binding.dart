import 'package:pg_managment/presentation/notification_screen/controller/notification_screen_controller.dart';
import 'package:get/get.dart';

  class NotificationScreenBinding extends Bindings {
  @override
  void dependencies() {   
    Get.lazyPut(() => NotificationScreenController());
  }
}
