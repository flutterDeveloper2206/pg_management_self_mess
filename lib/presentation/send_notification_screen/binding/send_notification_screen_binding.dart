import 'package:get/get.dart';
import '../controller/send_notification_screen_controller.dart';

class SendNotificationScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SendNotificationScreenController());
  }
}
