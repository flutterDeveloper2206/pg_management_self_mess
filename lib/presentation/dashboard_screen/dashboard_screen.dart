import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/commonConstant.dart';
import 'package:pg_managment/core/utils/pref_utils.dart';
import 'package:pg_managment/routes/app_routes.dart';
import 'controller/dashboard_screen_controller.dart';

class DashboardScreen extends GetWidget<DashboardScreenController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {
        'title': 'All Students',
        'icon': Icons.school, // More appropriate for student list
        'route': AppRoutes.studentListScreenRoute,
        'color': Colors.blueAccent,
      },
      {
        'title': 'Add Student',
        'icon': Icons.person_add, // Add person icon
        'route': AppRoutes.addStudentScreenRoute,
        'color': Colors.green,
      },
      {
        'title': 'All Expenses',
        'icon': Icons.receipt_long, // Represents bills/expenses
        'route': AppRoutes.expenseListScreenRoute,
        'color': Colors.deepPurple,
      },
      {
        'title': 'Add Expense',
        'icon': Icons.add_chart, // Add new expense/chart icon
        'route': AppRoutes.addExpenseScreenRoute,
        'color': Colors.orange,
      },
      {
        'title': 'Details List',
        'icon': Icons.fact_check, // Checklist/details icon
        'route': AppRoutes.allDetailsListScreenRoute,
        'color': Colors.teal,
      },
      {
        'title': 'Ganarate Bill',
        'icon': Icons.receipt, // Represents bills/expenses
        'route': AppRoutes.ganarateBillScreenRoute,
        'color': Colors.blueGrey,
      },
      {
        'title': 'Monthly Transaction',
        'icon': Icons.monetization_on, // Represents bills/expenses
        'route': AppRoutes.monthlyTransactionScreenRoute,
        'color': Colors.pinkAccent,
      },
      {
        'title': 'Deposit Details',
        'icon': Icons.payment, // Represents bills/expenses
        'route':  AppRoutes.depositDetailsScreenRoute,
        'color': Colors.redAccent,
      },{
        'title': 'Logout',
        'icon': Icons.exit_to_app, // Represents bills/expenses
        'route': '',
        'color': Colors.lightGreen,
      },
    ];
    final studentMenuItems = [
      {
        'title': 'Profile',
        'icon': Icons.person, // More appropriate for student list
        'route': AppRoutes.studentProfileScreenRoute,
        'color': Colors.deepPurple,
      },
      {
        'title': 'Monthly Details',
        'icon': Icons.fact_check, // Checklist/details icon
        'route': AppRoutes.dayDetailsListScreenRoute,
        'color': Colors.teal,
      },
      {
        'title': 'Logout',
        'icon': Icons.exit_to_app, // Represents bills/expenses
        'route': '',
        'color': Colors.red,
      },
    ];
    return Scaffold(
      backgroundColor: ColorConstant.primaryWhite,
      appBar: AppBar(
        backgroundColor: ColorConstant.primary,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Dashboard',
          style: PMT.appStyle(
            size: 24,
            fontWeight: FontWeight.bold,
            fontColor: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = constraints.maxWidth > 800
                ? 4
                : constraints.maxWidth > 600
                    ? 3
                    : 2;

            return GridView.builder(
              itemCount: CommonConstant.instance.isStudent
                  ? studentMenuItems.length
                  : menuItems.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final item = CommonConstant.instance.isStudent
                    ? studentMenuItems[index]
                    : menuItems[index];
                return _DashboardTile(
                  title: item['title'] as String,
                  icon: item['icon'] as IconData,
                  color: item['color'] as Color,
                  onTap: () {
                    if(item['route'].toString()
                        .isNotEmpty) {
                      Get.toNamed(item['route'] as String);
                    }else{
                      PrefUtils.clearPreferencesData();
                      Get.offAllNamed(AppRoutes.loginScreenRoute);
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _DashboardTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DashboardTile({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_DashboardTile> createState() => _DashboardTileState();
}

class _DashboardTileState extends State<_DashboardTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _isHovered ? widget.color.withOpacity(0.85) : widget.color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.3),
                blurRadius: 12,
                offset: Offset(0, 6),
              )
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 48, color: Colors.white),
              const SizedBox(height: 16),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: PMT.appStyle(
                  size: 16,
                  fontWeight: FontWeight.bold,
                  fontColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
