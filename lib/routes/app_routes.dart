import 'package:pg_managment/presentation/add_student_screen/add_student_screen.dart';
import 'package:pg_managment/presentation/add_student_screen/binding/add_student_screen_binding.dart';
import 'package:pg_managment/presentation/dashboard_screen/binding/dashboard_screen_binding.dart';
import 'package:pg_managment/presentation/dashboard_screen/dashboard_screen.dart';
import 'package:pg_managment/presentation/login_screen/binding/login_screen_binding.dart';
import 'package:pg_managment/presentation/login_screen/login_screen.dart';
import 'package:get/get.dart';
import 'package:pg_managment/presentation/splash_screen/binding/splash_screen_binding.dart';
import 'package:pg_managment/presentation/splash_screen/splash_screen.dart';
import 'package:pg_managment/presentation/student_list_screen/binding/student_list_screen_binding.dart';
import 'package:pg_managment/presentation/student_list_screen/student_list_screen.dart';

class AppRoutes {
  static const String splashScreenRoute = '/splash_screen';

  static const String loginScreenRoute = '/login_screen';

  static const String dashboardScreenRoute = '/dashboard_screen';

  static const String addStudentScreenRoute = '/add_student_screen';

  static const String studentListScreenRoute = '/student_list_screen';

  static const String notificationScreenRoute = '/notification_screen';

  static List<GetPage> pages = [
    GetPage(
        name: splashScreenRoute,
        page: () => const SplashScreen(),
        bindings: [
          SplashScreenBinding(),
        ],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300)),
    GetPage(
        name: loginScreenRoute,
        page: () => const LoginScreen(),
        bindings: [
          LoginScreenBinding(),
        ],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300)),
    GetPage(
        name: dashboardScreenRoute,
        page: () => const DashboardScreen(),
        bindings: [
          DashboardScreenBinding(),
        ],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300)),
    GetPage(
        name: addStudentScreenRoute,
        page: () => const AddStudentScreen(),
        bindings: [
          AddStudentScreenBinding(),
        ],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300)),
    GetPage(
        name: studentListScreenRoute,
        page: () => const StudentListScreen(),
        bindings: [
          StudentListScreenBinding(),
        ],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300)),
  ];
}
