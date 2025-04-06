import 'package:pg_managment/presentation/_screen/controller/_screen_controller.dart';
import 'package:get/get.dart';
import 'package:pg_managment/presentation/student_list_screen/controller/student_list_screen_controller.dart';

  class StudentListScreenBinding extends Bindings {
  @override
  void dependencies() {   
    Get.lazyPut(() => StudentListScreenController());
  }
}
