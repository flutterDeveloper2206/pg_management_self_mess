import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/commonConstant.dart';
import 'package:pg_managment/core/utils/pref_utils.dart';
import 'package:pg_managment/routes/app_routes.dart';
import 'package:pg_managment/widgets/custom_image_view.dart';
import 'controller/dashboard_screen_controller.dart';

class DashboardScreen extends GetWidget<DashboardScreenController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final staffSecretary = [
      {
        'title': 'All Students',
        'icon': 'assets/images/graduation.png',
        'route': AppRoutes.studentListScreenRoute,
        'color': const Color(0xFF4A90E2),
      },
      {
        'title': 'All Expenses',
        'icon': 'assets/images/bold.png',
        'route': AppRoutes.expenseListScreenRoute,
        'color': const Color(0xFF9B59B6),
      },
      {
        'title': 'Add Expense',
        'icon': 'assets/images/invoice.png',
        'route': AppRoutes.addExpenseScreenRoute,
        'color': const Color(0xFFE67E22),
      },
      {
        'title': 'Monthly Summary',
        'icon': 'assets/images/check-document.png',
        'route': AppRoutes.allDetailsListScreenRoute,
        'color': const Color(0xFF1ABC9C),
      },  {
        'title': 'Impport Data',
        'icon': 'assets/images/import.png',
        'route': AppRoutes.importScreenRoute,
        'color': const Color(0xFF1CA7AF),
      },
      // {
      //   'title': 'Today\'s Menu',
      //   'icon': 'assets/images/invoice.png',
      //   'route': AppRoutes.menuScreenRoute,
      //   'color': const Color(0xFF5E59B3),
      // },
      {
        'title': 'Logout',
        'icon': 'assets/images/exit.png',
        'route': '',
        'color': const Color(0xFFE74C3C),
      }
    ];
    final menuItems = [
      {
        'title': 'All Students',
        'icon': 'assets/images/graduation.png',
        'route': AppRoutes.studentListScreenRoute,
        'color': const Color(0xFF4A90E2),
      },
      {
        'title': 'Add Student',
        'icon': 'assets/images/student.png',
        'route': AppRoutes.addStudentScreenRoute,
        'color': const Color(0xFF50C878),
      },
      {
        'title': 'All Expenses',
        'icon': 'assets/images/bold.png',
        'route': AppRoutes.expenseListScreenRoute,
        'color': const Color(0xFF9B59B6),
      },
      {
        'title': 'Add Expense',
        'icon': 'assets/images/invoice.png',
        'route': AppRoutes.addExpenseScreenRoute,
        'color': const Color(0xFFE67E22),
      },
      {
        'title': 'Monthly Summary',
        'icon': 'assets/images/check-document.png',
        'route': AppRoutes.allDetailsListScreenRoute,
        'color': const Color(0xFF1ABC9C),
      },
      {
        'title': 'Generate Bill',
        'icon': 'assets/images/bill.png',
        'route': AppRoutes.ganarateBillScreenRoute,
        'color': const Color(0xFF34495E),
      },
      {
        'title': 'Monthly Transaction',
        'icon': 'assets/images/transaction.png',
        'route': AppRoutes.monthlyTransactionScreenRoute,
        'color': const Color(0xFFE91E63),
      },
      {
        'title': 'Deposit Details',
        'icon': 'assets/images/deposit.png',
        'route': AppRoutes.depositDetailsScreenRoute,
        'color': const Color(0xFFF39C12),
      },
      {
        'title': 'Config',
        'icon': 'assets/images/setting.png',
        'route': AppRoutes.configScreenRoute,
        'color': const Color(0xFF95A5A6),
      },

      {
        'title': 'Today\'s Menu',
        'icon': 'assets/images/invoice.png',
        'route': AppRoutes.menuScreenRoute,
        'color': const Color(0xFF5E59B3),
      },
      {
        'title': 'Logout',
        'icon': 'assets/images/exit.png',
        'route': '',
        'color': const Color(0xFFE74C3C),
      },
    ];

    final studentMenuItems = [
      {
        'title': 'Profile',
        'icon': 'assets/images/user.png',
        'route': AppRoutes.studentProfileScreenRoute,
        'color': const Color(0xFF4A90E2),
      },
      {
        'title': 'Monthly Details',
        'icon': 'assets/images/check-document.png',
        'route': AppRoutes.dayDetailsListScreenRoute,
        'color': const Color(0xFF1ABC9C),
      },
      // {
      //   'title': 'Today\'s Menu',
      //   'icon': 'assets/images/invoice.png',
      //   'route': AppRoutes.menuScreenRoute,
      //   'color': const Color(0xFF5E59B3),
      // },
      {
        'title': 'Logout',
        'icon': 'assets/images/exit.png',
        'route': '',
        'color': const Color(0xFFE74C3C),
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: ColorConstant.primary,
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 2,
        title: Text(
          'Dashboard',
          style: PMT.appStyle(
            size: 24,
            fontWeight: FontWeight.w600,
            fontColor: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  if(CommonConstant.instance.isStudent == 1 &&!kIsWeb){
                    menuItems.add( {
                      'title': 'Impport Data',
                      'icon': 'assets/images/import.png',
                      'route': AppRoutes.importScreenRoute,
                      'color': const Color(0xFF1CA7AF),
                    },);
                  }
                  int crossAxisCount = constraints.maxWidth > 800
                      ? 4
                      : constraints.maxWidth > 600
                          ? 3
                          : 2;
                  return GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: CommonConstant.instance.isStudent == 1
                        ? menuItems.length
                        : CommonConstant.instance.isStudent == 2 ||
                        CommonConstant.instance.isStudent == 3
                        ? staffSecretary.length
                        : studentMenuItems.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1.1,
                    ),
                    itemBuilder: (context, index) {
                      final item = CommonConstant.instance.isStudent == 1
                          ? menuItems[index]
                          :  CommonConstant.instance.isStudent == 2 ||
                          CommonConstant.instance.isStudent == 3
                          ? staffSecretary[index]
                          :studentMenuItems[index];
                      return CleanDashboardTile(
                        title: item['title'] as String,
                        icon: item['icon'] as String,
                        color: item['color'] as Color,
                        onTap: () {
                          if (item['route'].toString().isNotEmpty) {
                            Get.toNamed(item['route'] as String);
                          } else {
                            _showLogoutDialog(context);
                          }
                        },
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 20,),
              Text(
                'V(1.0.6)',
                textAlign: TextAlign.center,
                style: PMT.appStyle(
                  size: 16,
                  fontWeight: FontWeight.w600,
                  fontColor: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 20,),

            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Logout',
            style: PMT.appStyle(
              size: 18,
              fontWeight: FontWeight.w600,
              fontColor: Colors.black87,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: PMT.appStyle(
              size: 14,
              fontWeight: FontWeight.w400,
              fontColor: Colors.black54,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: PMT.appStyle(
                  size: 14,
                  fontWeight: FontWeight.w500,
                  fontColor: Colors.grey[600]!,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                PrefUtils.clearPreferencesData();
                Get.offAllNamed(AppRoutes.loginScreenRoute);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE74C3C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                'Logout',
                style: PMT.appStyle(
                  size: 14,
                  fontWeight: FontWeight.w500,
                  fontColor: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CleanDashboardTile extends StatefulWidget {
  final String title;
  final String icon;
  final Color color;
  final VoidCallback onTap;

  const CleanDashboardTile({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<CleanDashboardTile> createState() => _CleanDashboardTileState();
}

class _CleanDashboardTileState extends State<CleanDashboardTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon container
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: CustomImageView(
                  height: 40,
                  width: 40,
                  imagePath: widget.icon,
                  color: widget.color,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: PMT.appStyle(
                  size: 16,
                  fontWeight: FontWeight.w600,
                  fontColor: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pg_managment/core/utils/app_fonts.dart';
// import 'package:pg_managment/core/utils/color_constant.dart';
// import 'package:pg_managment/core/utils/commonConstant.dart';
// import 'package:pg_managment/core/utils/pref_utils.dart';
// import 'package:pg_managment/routes/app_routes.dart';
// import 'package:pg_managment/widgets/custom_image_view.dart';
// import 'controller/dashboard_screen_controller.dart';
//
// class DashboardScreen extends GetWidget<DashboardScreenController> {
//   const DashboardScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final menuItems = [
//       {
//         'title': 'All Students',
//         'icon': 'assets/images/graduation.png', // More appropriate for student list
//         'route': AppRoutes.studentListScreenRoute,
//         'color': Colors.blueAccent,
//       },
//       {
//         'title': 'Add Student',
//         'icon': 'assets/images/student.png', // Add person icon
//         'route': AppRoutes.addStudentScreenRoute,
//         'color': Colors.green,
//       },
//       {
//         'title': 'All Expenses',
//         'icon': 'assets/images/bold.png', // Represents bills/expenses
//         'route': AppRoutes.expenseListScreenRoute,
//         'color': Colors.deepPurple,
//       },
//       {
//         'title': 'Add Expense',
//         'icon': 'assets/images/invoice.png', // Add new expense/chart icon
//         'route': AppRoutes.addExpenseScreenRoute,
//         'color': Colors.orange,
//       },
//       {
//         'title': 'Monthly Summary',
//         'icon': 'assets/images/check-document.png', // Checklist/details icon
//         'route': AppRoutes.allDetailsListScreenRoute,
//         'color': Colors.teal,
//       },
//       {
//         'title': 'Ganarate Bill',
//         'icon': 'assets/images/bill.png', // Represents bills/expenses
//         'route': AppRoutes.ganarateBillScreenRoute,
//         'color': Colors.blueGrey,
//       },
//       {
//         'title': 'Monthly Transaction',
//         'icon': 'assets/images/transaction.png', // Represents bills/expenses
//         'route': AppRoutes.monthlyTransactionScreenRoute,
//         'color': Colors.pinkAccent,
//       },
//       {
//         'title': 'Deposit Details',
//         'icon': 'assets/images/deposit.png', // Represents bills/expenses
//         'route': AppRoutes.depositDetailsScreenRoute,
//         'color': Colors.redAccent,
//       },
//       {
//         'title': 'Config',
//         'icon': 'assets/images/setting.png', // Represents bills/expenses
//         'route': AppRoutes.configScreenRoute,
//         'color': Colors.greenAccent,
//       },
//       {
//         'title': 'Logout',
//         'icon': 'assets/images/exit.png', // Represents bills/expenses
//         'route': '',
//         'color': Colors.lightGreen,
//       },
//     ];
//     final studentMenuItems = [
//       {
//         'title': 'Profile',
//         'icon': 'assets/images/user.png', // Checklist/details icon
//         'route': AppRoutes.studentProfileScreenRoute,
//         'color': Colors.deepPurple,
//       },
//       {
//         'title': 'Monthly Details',
//         'icon': 'assets/images/check-document.png', // Checklist/details icon
//         'route': AppRoutes.dayDetailsListScreenRoute,
//         'color': Colors.teal,
//       },
//       {
//         'title': 'Logout',
//         'icon': 'assets/images/exit.png', // Represents bills/expenses
//         'route': '',
//         'color': Colors.red,
//       },
//     ];
//     return Scaffold(
//       backgroundColor: ColorConstant.primaryWhite,
//       appBar: AppBar(
//         backgroundColor: ColorConstant.primary,
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//         title: Text(
//           'Dashboard',
//           style: PMT.appStyle(
//             size: 24,
//             fontWeight: FontWeight.bold,
//             fontColor: Colors.white,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             int crossAxisCount = constraints.maxWidth > 800
//                 ? 4
//                 : constraints.maxWidth > 600
//                     ? 3
//                     : 2;
//
//             return GridView.builder(
//               itemCount: CommonConstant.instance.isStudent
//                   ? studentMenuItems.length
//                   : menuItems.length,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: crossAxisCount,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//                 childAspectRatio: 1,
//               ),
//               itemBuilder: (context, index) {
//                 final item = CommonConstant.instance.isStudent
//                     ? studentMenuItems[index]
//                     : menuItems[index];
//                 return _DashboardTile(
//                   title: item['title'] as String,
//                   icon: item['icon'] as String,
//                   color: item['color'] as Color,
//                   onTap: () {
//                     if (item['route'].toString().isNotEmpty) {
//                       Get.toNamed(item['route'] as String);
//                     } else {
//                       PrefUtils.clearPreferencesData();
//                       Get.offAllNamed(AppRoutes.loginScreenRoute);
//                     }
//                   },
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class _DashboardTile extends StatefulWidget {
//   final String title;
//   final String icon;
//   final Color color;
//   final VoidCallback onTap;
//
//   const _DashboardTile({
//     required this.title,
//     required this.icon,
//     required this.color,
//     required this.onTap,
//   });
//
//   @override
//   State<_DashboardTile> createState() => _DashboardTileState();
// }
//
// class _DashboardTileState extends State<_DashboardTile> {
//   bool _isHovered = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//       onEnter: (_) => setState(() => _isHovered = true),
//       onExit: (_) => setState(() => _isHovered = false),
//       child: GestureDetector(
//         onTap: widget.onTap,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           decoration: BoxDecoration(
//             color: _isHovered ? widget.color.withOpacity(0.85) : widget.color,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: widget.color.withOpacity(0.3),
//                 blurRadius: 12,
//                 offset: Offset(0, 6),
//               )
//             ],
//           ),
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CustomImageView(
//                   height: 50,
//                   width: 50,
//                   imagePath:  widget.icon ,color: Colors.white),
//               // Icon(widget.icon, size: 48, color: Colors.white),
//               const SizedBox(height: 16),
//               Text(
//                 widget.title,
//                 textAlign: TextAlign.center,
//                 style: PMT.appStyle(
//                   size: 16,
//                   fontWeight: FontWeight.bold,
//                   fontColor: Colors.white,
//                 ),
//               ),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
