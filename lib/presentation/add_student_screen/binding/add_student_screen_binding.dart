import 'package:get/get.dart';
import 'package:pg_managment/presentation/add_student_screen/controller/add_student_screen_controller.dart';

  class AddStudentScreenBinding extends Bindings {
  @override
  void dependencies() {   
    Get.lazyPut(() => AddStudentScreenController());
  }
}
