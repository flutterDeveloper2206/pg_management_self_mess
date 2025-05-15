import 'package:get/get.dart';
import 'package:pg_managment/presentation/student_profile_screen/controller/student_profile_screen_controller.dart';

  class StudentProfileScreenBinding extends Bindings {
  @override
  void dependencies() {   
    Get.lazyPut(() => StudentProfileScreenController());
  }
}
