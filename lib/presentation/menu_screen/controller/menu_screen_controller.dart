import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pg_managment/ApiServices/api_service.dart';
import 'package:pg_managment/core/utils/app_network_urls.dart';
import 'package:pg_managment/core/utils/common_function.dart';
import 'package:pg_managment/core/utils/navigation_service.dart';
import 'package:pg_managment/core/utils/progress_dialog_utils.dart';
import 'package:pg_managment/presentation/menu_screen/model/day_meal_model.dart';

class MenuScreenController extends GetxController {
  var selectedDay = 'monday'.obs;
  final List<String> days = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday'
  ];

  RxList<MealData> meals = <MealData>[].obs;
  RxBool isLoading = false.obs;
  final ScrollController dayScrollController = ScrollController();

  @override
  void onInit() {
    _setTodayAsDefault();
    getMeals();
    super.onInit();
  }

  @override
  void onReady() {
    scrollToSelectedDay();
    super.onReady();
  }

  void _setTodayAsDefault() {
    int weekday = DateTime.now().weekday;
    String today = 'monday';
    switch (weekday) {
      case 1:
        today = 'monday';
        break;
      case 2:
        today = 'tuesday';
        break;
      case 3:
        today = 'wednesday';
        break;
      case 4:
        today = 'thursday';
        break;
      case 5:
        today = 'friday';
        break;
      case 6:
        today = 'saturday';
        break;
      case 7:
        today = 'sunday';
        break;
    }
    selectedDay.value = today;
  }

  void scrollToSelectedDay() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Add a tiny delay to ensure the scroll controller is fully attached
      await Future.delayed(const Duration(milliseconds: 100));
      if (dayScrollController.hasClients) {
        int index = days.indexOf(selectedDay.value);
        if (index != -1) {
          double screenWidth = Get.width;
          double itemWidth = 72.0; // 60 width + 12 gap
          double offset =
              (index * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

          if (offset < 0) offset = 0;
          if (offset > dayScrollController.position.maxScrollExtent) {
            offset = dayScrollController.position.maxScrollExtent;
          }

          dayScrollController.animateTo(
            offset,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
          );
        }
      }
    });
  }

  Future<void> getMeals() async {
    isLoading.value = true;
    await ApiService().callGetApi(
      body: {},
      url: NetworkUrls.dayMealsUrl,
      showLoader: false,
    ).then((value) {
      isLoading.value = false;
      if (value != null && value.statusCode == 200) {
        DayMealModel model = DayMealModel.fromJson(value.body);
        meals.assignAll(model.data ?? []);
        // Trigger scroll after data is loaded and UI is updated
        scrollToSelectedDay();
      }
    });
  }

  Future<void> updateMeal(
      int id, String breakfast, String lunch, String dinner) async {
    await ApiService().callPutApi(
      body: {
        'breakfast': breakfast,
        'lunch': lunch,
        'dinner': dinner,
      },
      url: "${NetworkUrls.dayMealsUrl}/$id",
      showLoader: true,
    ).then((value) {
      if (value != null && value.statusCode == 200) {
        getMeals(); // Refresh list after update
        AppFlushBars.appCommonFlushBar(
          context: NavigationService.navigatorKey.currentContext!,
          message: 'Meal updated successfully',
          success: true,
        );
      }
    });
  }

  void selectDay(String day) {
    selectedDay.value = day;
    scrollToSelectedDay();
  }

  MealData? get currentDayMeal {
    try {
      return meals.firstWhere((element) =>
          element.day?.toLowerCase() == selectedDay.value.toLowerCase());
    } catch (e) {
      return null;
    }
  }

  MealData? get todayMeal {
    String today = DateTime.now().weekday == 1
        ? 'monday'
        : DateTime.now().weekday == 2
            ? 'tuesday'
            : DateTime.now().weekday == 3
                ? 'wednesday'
                : DateTime.now().weekday == 4
                    ? 'thursday'
                    : DateTime.now().weekday == 5
                        ? 'friday'
                        : DateTime.now().weekday == 6
                            ? 'saturday'
                            : 'sunday';
    try {
      return meals.firstWhere((element) => element.day?.toLowerCase() == today);
    } catch (e) {
      return null;
    }
  }
}
