import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/commonConstant.dart';
import 'package:pg_managment/core/utils/size_utils.dart';
import 'package:pg_managment/widgets/bouncing_button.dart';
import 'controller/menu_screen_controller.dart';

import 'model/day_meal_model.dart';

class MenuScreen extends GetWidget<MenuScreenController> {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgGrey,
      appBar: AppBar(
        backgroundColor: ColorConstant.bgGrey,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Weekly Menu',
          style: PMT.appStyle(
            size: 20,
            fontWeight: FontWeight.w700,
            fontColor: ColorConstant.primaryBlack,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: ColorConstant.primaryBlack, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.meals.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        MealData? currentMeal = controller.currentDayMeal;
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTodayMenuCard(),
              const SizedBox(height: 20),
              Text(
                "Select Day",
                style: PMT.appStyle(
                  size: 18,
                  fontWeight: FontWeight.w700,
                  fontColor: ColorConstant.primaryBlack,
                ),
              ),
              const SizedBox(height: 10),
              _buildDaySelector(),
              const SizedBox(height: 20),
              _buildMenuSection(
                'Breakfast',
                currentMeal?.breakfast ?? 'No menu added',
                Icons.wb_sunny_rounded,
                const Color(0xFFFFA726),
                const Color(0xFFFFF3E0),
                0,
              ),
              const SizedBox(height: 12),
              _buildMenuSection(
                'Lunch',
                currentMeal?.lunch ?? 'No menu added',
                Icons.restaurant_menu_rounded,
                const Color(0xFFEF5350),
                const Color(0xFFFFEBEE),
                1,
              ),
              const SizedBox(height: 12),
              _buildMenuSection(
                'Dinner',
                currentMeal?.dinner ?? 'No menu added',
                Icons.nights_stay_rounded,
                ColorConstant.primary,
                ColorConstant.primary.withOpacity(0.1),
                2,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTodayMenuCard() {
    return Obx(() {
      MealData? displayMeal = controller.currentDayMeal;
      String formattedDate = DateFormat('EEEE, d MMM').format(DateTime.now());

      // If the selected day is not today, we should probably show the day name of the selected day
      String cardTitle = "Today's Special";
      if (controller.selectedDay.value.toLowerCase() !=
          controller.days[DateTime.now().weekday - 1].toLowerCase()) {
        cardTitle = "${controller.selectedDay.value.capitalizeFirst}'s Special";
      }

      return TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 800),
        tween: Tween(begin: 0.0, end: 1.0),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: Opacity(
              opacity: value.clamp(0.0, 1.0),
              child: child,
            ),
          );
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: ColorConstant.primary.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        ColorConstant.primary,
                        const Color(0xFF6B4EE6),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                formattedDate,
                                style: PMT.appStyle(
                                  size: 14,
                                  fontWeight: FontWeight.w500,
                                  fontColor: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              Text(
                                cardTitle,
                                style: PMT.appStyle(
                                  size: 20,
                                  fontWeight: FontWeight.w800,
                                  fontColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          if (CommonConstant.instance.isStudent == 1)
                            Bounce(
                              onTap: () {
                                  _showEditMenuDialog(displayMeal!);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.edit_note_rounded,
                                    color: Colors.white, size: 22),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCompactTodayItem(Icons.wb_sunny_rounded,
                              displayMeal?.breakfast ?? '...', "Breakfast", 0),
                          _buildCompactTodayItem(Icons.restaurant_menu_rounded,
                              displayMeal?.lunch ?? '...', "Lunch", 1),
                          _buildCompactTodayItem(Icons.nights_stay_rounded,
                              displayMeal?.dinner ?? '...', "Dinner", 2),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: -20,
                  top: -20,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white.withOpacity(0.05),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildCompactTodayItem(
      IconData icon, String menu, String label, int index) {
    return Expanded(
      child: TweenAnimationBuilder<double>(
        duration: Duration(milliseconds: 600 + (index * 200)),
        tween: Tween(begin: 0.0, end: 1.0),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: Transform.scale(
              scale: 0.9 + (0.1 * value),
              child: child,
            ),
          );
        },
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: PMT.appStyle(
                size: 11,
                fontWeight: FontWeight.w600,
                fontColor: Colors.white.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              menu,
              style: PMT.appStyle(
                size: 13,
                fontWeight: FontWeight.w700,
                fontColor: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayMenuItemAnimated(
      IconData icon, String text, String label, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 200)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: PMT.appStyle(
                    size: 13,
                    fontWeight: FontWeight.w600,
                    fontColor: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: PMT.appStyle(
                    size: 16,
                    fontWeight: FontWeight.w700,
                    fontColor: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        controller: controller.dayScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: controller.days.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          String day = controller.days[index];
          bool isSelected = controller.selectedDay.value == day;
          return GestureDetector(
            onTap: () => controller.selectDay(day),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? ColorConstant.primary : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: ColorConstant.primary.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ]
                    : [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        )
                      ],
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : Colors.grey.withOpacity(0.2),
                ),
              ),
              child: Center(
                child: Text(
                  day.substring(0, 1).toUpperCase() +
                      day.substring(1, 3).toLowerCase(),
                  style: PMT.appStyle(
                    size: 15,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    fontColor:
                        isSelected ? Colors.white : ColorConstant.textGreyColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuSection(String title, String menu, IconData icon,
      Color iconColor, Color bgColor, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 150)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Icon(icon, color: iconColor, size: 24),
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  title,
                  style: PMT.appStyle(
                    size: 18,
                    fontWeight: FontWeight.w700,
                    fontColor: ColorConstant.primaryBlack,
                  ),
                ),
                const Spacer(),
                if (menu.isNotEmpty && menu != 'No menu added')
                  Icon(Icons.check_circle_rounded,
                      color: ColorConstant.green.withOpacity(0.7), size: 22),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: ColorConstant.bgGrey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                menu.isNotEmpty ? menu : "Not Available",
                style: PMT.appStyle(
                  size: 15,
                  fontWeight: FontWeight.w500,
                  fontColor: menu.isNotEmpty && menu != 'No menu added'
                      ? ColorConstant.textDarkBrown
                      : ColorConstant.textGreyColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditMenuDialog(MealData meal) {
    final breakfastController = TextEditingController(text: meal.breakfast);
    final lunchController = TextEditingController(text: meal.lunch);
    final dinnerController = TextEditingController(text: meal.dinner);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit Menu - ${meal.day?.toUpperCase()}",
                style: PMT.appStyle(
                  size: 20,
                  fontWeight: FontWeight.w700,
                  fontColor: ColorConstant.primaryBlack,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField("Breakfast", breakfastController),
              const SizedBox(height: 15),
              _buildTextField("Lunch", lunchController),
              const SizedBox(height: 15),
              _buildTextField("Dinner", dinnerController),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (meal.id != null) {
                      controller.updateMeal(
                        meal.id!,
                        breakfastController.text.trim(),
                        lunchController.text.trim(),
                        dinnerController.text.trim(),
                      );
                      Get.back();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstant.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Update Menu",
                    style: PMT.appStyle(
                      size: 16,
                      fontWeight: FontWeight.w600,
                      fontColor: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildTextField(String label, TextEditingController textController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: PMT.appStyle(
              size: 14,
              fontWeight: FontWeight.w600,
              fontColor: ColorConstant.textGreyColor),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: textController,
          decoration: InputDecoration(
            fillColor: ColorConstant.bgGrey,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}
