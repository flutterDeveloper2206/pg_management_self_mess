import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/size_utils.dart';
import 'controller/menu_screen_controller.dart';

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
          icon: const Icon(Icons.arrow_back_ios_new, color: ColorConstant.primaryBlack, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
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
                controller.currentDayMenu['breakfast'] ?? 'No menu added',
                Icons.wb_sunny_rounded,
                const Color(0xFFFFA726),
                const Color(0xFFFFF3E0),
              ),
              const SizedBox(height: 12),
              _buildMenuSection(
                'Lunch',
                controller.currentDayMenu['lunch'] ?? 'No menu added',
                Icons.restaurant_menu_rounded,
                const Color(0xFFEF5350),
                const Color(0xFFFFEBEE),
              ),
              const SizedBox(height: 12),
              _buildMenuSection(
                'Dinner',
                controller.currentDayMenu['dinner'] ?? 'No menu added',
                Icons.nights_stay_rounded,
                ColorConstant.primary,
                ColorConstant.primary.withOpacity(0.1),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTodayMenuCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorConstant.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: ColorConstant.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorConstant.primary,
            ColorConstant.primary.withOpacity(0.8),
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
                    "Today's Special",
                    style: PMT.appStyle(
                      size: 22,
                      fontWeight: FontWeight.w700,
                      fontColor: Colors.white,
                    ),
                  ),
                  Text(
                    "Delicious meals for you",
                    style: PMT.appStyle(
                      size: 14,
                      fontWeight: FontWeight.w400,
                      fontColor: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit_note_rounded, color: Colors.white, size: 22),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTodayMenuItem(Icons.wb_sunny_rounded, controller.menuData['Mon']?['breakfast'] ?? 'Loading...', "Breakfast"),
          const SizedBox(height: 12),
          _buildTodayMenuItem(Icons.restaurant_menu_rounded, controller.menuData['Mon']?['lunch'] ?? 'Loading...', "Lunch"),
          const SizedBox(height: 12),
          _buildTodayMenuItem(Icons.nights_stay_rounded, controller.menuData['Mon']?['dinner'] ?? 'Loading...', "Dinner"),
        ],
      ),
    );
  }

  Widget _buildTodayMenuItem(IconData icon, String text, String label) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: PMT.appStyle(
                  size: 12,
                  fontWeight: FontWeight.w600,
                  fontColor: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                text,
                style: PMT.appStyle(
                  size: 15,
                  fontWeight: FontWeight.w600,
                  fontColor: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDaySelector() {
    return SizedBox(
      height: 50,
      child: ListView.separated(
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
                  color: isSelected ? Colors.transparent : Colors.grey.withOpacity(0.2),
                ),
              ),
              child: Center(
                child: Text(
                  day,
                  style: PMT.appStyle(
                    size: 15,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    fontColor: isSelected ? Colors.white : ColorConstant.textGreyColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuSection(String title, String menu, IconData icon, Color iconColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
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
              if (menu.isNotEmpty)
                Icon(Icons.check_circle_rounded, color: ColorConstant.green.withOpacity(0.7), size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Container(
             width: double.infinity,
             padding: const EdgeInsets.all(16),
             decoration: BoxDecoration(
               color: ColorConstant.bgGrey,
               borderRadius: BorderRadius.circular(12),
             ),
             child: Text(
              menu.isNotEmpty ? menu : "Not Available",
              style: PMT.appStyle(
                size: 14,
                fontWeight: FontWeight.w500,
                fontColor: menu.isNotEmpty 
                  ? ColorConstant.textDarkBrown 
                  : ColorConstant.textGreyColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
