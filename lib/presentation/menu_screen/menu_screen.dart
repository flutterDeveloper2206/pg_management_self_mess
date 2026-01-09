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


      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Menu',
          style: PMT.appStyle(
            size: 20,
            fontWeight: FontWeight.w700,
            fontColor: ColorConstant.primaryBlack,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
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
              const SizedBox(height: 25),
              _buildDaySelector(),
              const SizedBox(height: 30),
              _buildMenuSection(
                'Breakfast',
                controller.currentDayMenu['breakfast'] ?? '',
                Icons.wb_sunny,
                const Color(0xFFFDBB49),
                const Color(0xFFFFF4E0),
              ),
              _buildDivider(),
              _buildMenuSection(
                'Lunch',
                controller.currentDayMenu['lunch'] ?? '',
                Icons.restaurant,
                const Color(0xFFFDBB49),
                const Color(0xFFFFF4E0),
              ),
              _buildDivider(),
              _buildMenuSection(
                'Dinner',
                controller.currentDayMenu['dinner'] ?? '',
                Icons.nightlight_round,
                const Color(0xFF5E59B3),
                const Color(0xFFECEBFF),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTodayMenuCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF5E59B3),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Menu",
                style: PMT.appStyle(
                  size: 24,
                  fontWeight: FontWeight.w600,
                  fontColor: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, color: Colors.white, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildTodayMenuItem(Icons.wb_sunny, controller.menuData['Mon']?['breakfast'] ?? '', hasRating: true),
          const SizedBox(height: 16),
          _buildTodayMenuItem(Icons.cloud, controller.menuData['Mon']?['lunch'] ?? ''),
          const SizedBox(height: 16),
          _buildTodayMenuItem(Icons.nightlight_round, controller.menuData['Mon']?['dinner'] ?? ''),
        ],
      ),
    );
  }

  Widget _buildTodayMenuItem(IconData icon, String text, {bool hasRating = false}) {
    return Row(
      children: [
        Icon(icon, color: Colors.orangeAccent, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: PMT.appStyle(
              size: 18,
              fontWeight: FontWeight.w500,
              fontColor: Colors.white,
            ),
          ),
        ),
        if (hasRating)
          Row(
            children: List.generate(4, (index) => const Icon(Icons.star, color: Color(0xFF8B87D1), size: 20)),
          ),
      ],
    );
  }

  Widget _buildDaySelector() {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.days.length,
        itemBuilder: (context, index) {
          String day = controller.days[index];
          bool isSelected = controller.selectedDay.value == day;
          return GestureDetector(
            onTap: () => controller.selectDay(day),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF5E59B3) : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  day,
                  style: PMT.appStyle(
                    size: 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontColor: isSelected ? Colors.white : Colors.grey[600],
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: PMT.appStyle(
              size: 22,
              fontWeight: FontWeight.w600,
              fontColor: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(icon, color: iconColor, size: 30),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  menu,
                  style: PMT.appStyle(
                    size: 18,
                    fontWeight: FontWeight.w500,
                    fontColor: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[200],
      height: 1,
      thickness: 1,
    );
  }
}
