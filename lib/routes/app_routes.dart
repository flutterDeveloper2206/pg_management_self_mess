import 'package:pg_managment/presentation/add_expense_screen/add_expense_screen.dart';
import 'package:pg_managment/presentation/add_expense_screen/binding/add_expense_screen_binding.dart';
import 'package:pg_managment/presentation/add_student_screen/add_student_screen.dart';
import 'package:pg_managment/presentation/add_student_screen/binding/add_student_screen_binding.dart';
import 'package:pg_managment/presentation/add_update_day_details_screen/add_update_day_details_screen.dart';
import 'package:pg_managment/presentation/add_update_day_details_screen/binding/add_update_day_details_screen_binding.dart';
import 'package:pg_managment/presentation/all_details_list_screen/all_details_list_screen.dart';
import 'package:pg_managment/presentation/all_details_list_screen/binding/all_details_list_screen_binding.dart';
import 'package:pg_managment/presentation/dashboard_screen/binding/dashboard_screen_binding.dart';
import 'package:pg_managment/presentation/dashboard_screen/dashboard_screen.dart';
import 'package:pg_managment/presentation/day_details_list_screen/binding/day_details_list_screen_binding.dart';
import 'package:pg_managment/presentation/day_details_list_screen/day_details_list_screen.dart';
import 'package:pg_managment/presentation/deposit_details_screen/binding/deposit_details_screen_binding.dart';
import 'package:pg_managment/presentation/deposit_details_screen/deposit_details_screen.dart';
import 'package:pg_managment/presentation/expense_list_screen/binding/expense_list_screen_binding.dart';
import 'package:pg_managment/presentation/expense_list_screen/expense_list_screen.dart';
import 'package:pg_managment/presentation/login_screen/binding/login_screen_binding.dart';
import 'package:pg_managment/presentation/login_screen/login_screen.dart';
import 'package:get/get.dart';
import 'package:pg_managment/presentation/splash_screen/binding/splash_screen_binding.dart';
import 'package:pg_managment/presentation/splash_screen/splash_screen.dart';
import 'package:pg_managment/presentation/student_list_screen/binding/student_list_screen_binding.dart';
import 'package:pg_managment/presentation/student_list_screen/student_list_screen.dart';
import 'package:pg_managment/presentation/ganarate_bill_screen/ganarate_bill_screen.dart';
import 'package:pg_managment/presentation/ganarate_bill_screen/binding/ganarate_bill_screen_binding.dart';
import 'package:pg_managment/presentation/monthly_transaction_screen/monthly_transaction_screen.dart';
import 'package:pg_managment/presentation/monthly_transaction_screen/binding/monthly_transaction_screen_binding.dart';
import 'package:pg_managment/presentation/student_profile_screen/binding/student_profile_screen_binding.dart';
import 'package:pg_managment/presentation/student_profile_screen/student_profile_screen.dart';

class AppRoutes {
  static const String splashScreenRoute = '/splash_screen';

  static const String loginScreenRoute = '/login_screen';

  static const String dashboardScreenRoute = '/dashboard_screen';

  static const String addStudentScreenRoute = '/add_student_screen';

  static const String addExpenseScreenRoute = '/add_expense_screen';

  static const String allDetailsListScreenRoute = '/all_details_list_screen';

  static const String dayDetailsListScreenRoute = '/day_details_list_screen';

  static const String ganarateBillScreenRoute = '/ganarate_bill_screen';

  static const String addUpdateDayDetailsScreenRoute =
      '/add_update_day_details_route';

  static const String studentListScreenRoute = '/student_list_screen';

  static const String expenseListScreenRoute = '/expense_list_screen';

  static const String notificationScreenRoute = '/notification_screen';

  static const String studentProfileScreenRoute = '/student_profile_screen';

  static const String monthlyTransactionScreenRoute =
      '/monthly_transaction_screen';
  static const String depositDetailsScreenRoute =
      '/deposit_details_screen';

  static List<GetPage> pages = [
    GetPage(
        name: splashScreenRoute,
        page: () => const SplashScreen(),
        bindings: [
          SplashScreenBinding(),
        ],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 100)),
    GetPage(
        name: loginScreenRoute,
        page: () => const LoginScreen(),
        bindings: [
          LoginScreenBinding(),
        ],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 100)),
    GetPage(
        name: dashboardScreenRoute,
        page: () => const DashboardScreen(),
        bindings: [
          DashboardScreenBinding(),
        ],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 100)),
    GetPage(
        name: addStudentScreenRoute,
        page: () => const AddStudentScreen(),
        bindings: [
          AddStudentScreenBinding(),
        ],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 100)),
    GetPage(
        name: studentListScreenRoute,
        page: () => const StudentListScreen(),
        bindings: [
          StudentListScreenBinding(),
        ],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 100)),
    GetPage(
        name: expenseListScreenRoute,
        page: () => const ExpenseListScreen(),
        bindings: [
          ExpenseListScreenBinding(),
        ],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 100)),
    GetPage(
        name: addExpenseScreenRoute,
        page: () => const AddExpenseScreen(),
        bindings: [
          AddExpenseScreenBinding(),
        ],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 100)),
    GetPage(
        name: allDetailsListScreenRoute,
        page: () => const AllDetailsListScreen(),
        bindings: [
          AllDetailsListScreenBinding(),
        ],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 100)),
    GetPage(
        name: dayDetailsListScreenRoute,
        page: () => const DayDetailsListScreen(),
        bindings: [
          DayDetailsListScreenBinding(),
        ],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 100)),
    GetPage(
        name: addUpdateDayDetailsScreenRoute,
        page: () => const AddUpdateDayDetailsScreen(),
        bindings: [
          AddUpdateDayDetailsScreenBinding(),
        ],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 100)),
    GetPage(
        name: ganarateBillScreenRoute,
        page: () => const GanarateBillScreen(),
        bindings: [
          GanarateBillScreenBinding(),
        ],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 100)),
    GetPage(
        name: monthlyTransactionScreenRoute,
        page: () => const MonthlyTransactionScreen(),
        bindings: [
          MonthlyTransactionScreenBinding(),
        ],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 100)),  GetPage(
        name: depositDetailsScreenRoute,
        page: () => const DepositDetailsScreen(),
        bindings: [
          DepositDetailsScreenBinding(),
        ],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 100)),    GetPage(
        name: studentProfileScreenRoute,
        page: () => const StudentProfileScreen(),
        bindings: [
          StudentProfileScreenBinding(),
        ],
        transition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 100)),
  ];
}
