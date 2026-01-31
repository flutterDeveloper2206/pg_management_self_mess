import 'package:flutter/material.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';


class MonthYearPicker {
  static Future<DateTime?> show(BuildContext context, {DateTime? initialDate}) async {
    DateTime now = initialDate ?? DateTime.now();
    int selectedMonth = now.month;
    int selectedYear = now.year;

    final List<String> months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    return showDialog<DateTime>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(
                "Select Month & Year",
                textAlign: TextAlign.center,
                style: PMT.appStyle(size: 18, fontWeight: FontWeight.w700),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, size: 18),
                        onPressed: () => setState(() => selectedYear--),
                      ),
                      Text(
                        "$selectedYear",
                        style: PMT.appStyle(size: 20, fontWeight: FontWeight.w700, fontColor: ColorConstant.primary),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 18),
                        onPressed: () => setState(() => selectedYear++),
                      ),
                    ],
                  ),
                  const Divider(),
                  SizedBox(
                    width: 300,
                    height: 250,
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        bool isSelected = selectedMonth == index + 1;
                        return GestureDetector(
                          onTap: () => setState(() => selectedMonth = index + 1),
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isSelected ? ColorConstant.primary : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? ColorConstant.primary : Colors.grey.shade300,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                months[index].substring(0, 3),
                                style: PMT.appStyle(
                                  size: 14,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  fontColor: isSelected ? Colors.white : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel", style: PMT.appStyle(fontColor: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstant.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => Navigator.pop(context, DateTime(selectedYear, selectedMonth)),
                  child: Text("Select", style: PMT.appStyle(fontColor: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
