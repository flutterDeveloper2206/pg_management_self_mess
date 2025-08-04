// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:pg_managment/core/utils/app_fonts.dart';
// import 'package:pg_managment/core/utils/color_constant.dart';
// import 'package:pg_managment/core/utils/size_utils.dart';
// import 'package:pg_managment/widgets/custom_elavated_button.dart';
// import 'package:printing/printing.dart';
// import 'controller/monthly_transaction_screen_controller.dart';
// import 'package:pg_managment/widgets/custom_app_text_form_field.dart';
//
// class MonthlyTransactionScreen
//     extends GetWidget<MonthlyTransactionScreenController> {
//   const MonthlyTransactionScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorConstant.primaryWhite,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: ColorConstant.primary,
//         leading: IconButton(
//           onPressed: () => Get.back(),
//           icon: const Icon(Icons.arrow_back_ios, color: ColorConstant.primaryWhite),
//         ),
//         title: Text('Monthly Transaction', style: PMT.appStyle(size: 20, fontColor: ColorConstant.primaryWhite)),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 16.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: CustomAppTextFormField(
//                       controller: controller.monthController,
//                       onTap: () => controller.selectMonth(context),
//                       readOnly: true,
//                       variant: TextFormFieldVariant.OutlineGray200,
//                       hintText: 'Select Month',
//                     ),
//                   ),
//                   hBox(10),
//                   Expanded(
//                     child: CustomAppTextFormField(
//                       controller: controller.yearController,
//                       onTap: () => controller.selectYear(context),
//                       readOnly: true,
//                       variant: TextFormFieldVariant.OutlineGray200,
//                       hintText: 'Select Year',
//                     ),
//                   ),
//                   hBox(10),
//                   TextButton(
//                     onPressed: () => controller.getMonthlyTransaction(),
//                     style: TextButton.styleFrom(
//                       backgroundColor: ColorConstant.primary,
//                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                     ),
//                     child: Text('GO', style: PMT.appStyle(size: 16, fontWeight: FontWeight.bold, fontColor: ColorConstant.primaryWhite)),
//                   ),
//                 ],
//               ),
//             ),
//             hBox(10),
//             Expanded(
//               child: Obx(() {
//                 if (controller.isLoading.value) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//
//                 // Note: Using 'monthlyTransactionList' as in your provided code
//                 final data = controller.monthlyTransactionList.value.data;
//
//                 if (data == null) {
//                   return const Center(child: Text('No data found for the selected period.'));
//                 }
//
//                 return ListView(
//                   padding: const EdgeInsets.only(top: 10, bottom: 20),
//                   children: [
//                     // --- Current Month Section ---
//                     _buildSectionHeader(
//                         'Current Month Summary (${_formatMonthName(data.month)} ${data.year})'
//                     ),
//                     _buildInfoCard('Current Month Expense', _formatCurrency(data.currentMonthExpense)),
//                     _buildInfoCard('Total Guest Amount', _formatCurrency(data.currentMonthTotalGuestAmount)),
//                     _buildInfoCard('Total Collection', _formatCurrency(data.currentTotalCollection)),
//                     _buildInfoCard('Total Remaining', _formatCurrency(data.currentTotalRemaining)),
//                     _buildInfoCard('Total Cash On Hand', _formatCurrency(data.currentMonthTotalCashOnHand), isNegativeRed: true),
//                     _buildInfoCard('Net Amount for Month', _formatCurrency(data.currentMonthTotalAmount), isNegativeRed: true),
//                     _buildInfoCard('Profit / Loss', _formatCurrency(data.currentMonthProfit), isNegativeRed: true),
//
//                     const SizedBox(height: 24),
//
//                     // --- Day Summary Section ---
//                     _buildSectionHeader('Day Summary'),
//                     _buildInfoCard('Total Eat Days', _formatNumber(data.currentMonthTotalEatDay)),
//                     _buildInfoCard('Total Cut Days', _formatNumber(data.currentMonthTotalCutDay)),
//                     _buildInfoCard('Total Days (Eat+Cut)', _formatNumber(data.currentMonthTotalDay)),
//
//                     const SizedBox(height: 24),
//
//                     // --- Last Month Section ---
//                     _buildSectionHeader('Previous Month Comparison'),
//                     _buildInfoCard('Last Month Total Collection', _formatCurrency(data.lastMonthTotalCollection.toString())),
//                     _buildInfoCard('Last Month Cash On Hand', _formatCurrency(data.lastMonthTotalCaseOnHand.toString())),
//                     _buildInfoCard('Last Month Guest Amount', _formatCurrency(data.lastMonthTotalCashGuestAmount.toString())),
//                     _buildInfoCard('Last Month Total Amount', _formatCurrency(data.lastMonthTotalAmount.toString())),
//                   ],
//                 );
//               }),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 5),
//         child: AppElevatedButton(
//           buttonName: 'Download PDF',
//           onPressed: () async {
//             if (controller.monthlyTransactionList.value.data == null) {
//               Get.snackbar("Notice", "No data available to download.",
//                   snackPosition: SnackPosition.BOTTOM);
//               return;
//             }
//             final pdfData = await controller.generatePdf();
//             await Printing.sharePdf(
//               bytes: pdfData,
//               filename: 'Monthly_Report_${controller.yearController.text}_${controller.monthController.text}.pdf',
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   // --- Helper Widget for Section Headers ---
//   Widget _buildSectionHeader(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12, top: 8),
//       child: Text(
//         title,
//         style: PMT.appStyle(
//           size: 18,
//           fontWeight: FontWeight.bold,
//           fontColor: ColorConstant.primary,
//         ),
//       ),
//     );
//   }
//
//   // --- Type-Safe Helper Functions for Formatting ---
//
//   // Formats a number as currency (e.g., ₹ 15,200.00)
//   // IMPORTANT: This now accepts a double? for type safety.
//   String _formatCurrency(String? value) {
//     if (value == null) return 'N/A';
//     if (value == 'null') return 'N/A';
// // Using Indian Numbering System
//     double val = double.parse(value);
//     return NumberFormat.currency(
//       locale: 'en_IN',
//       symbol: '₹ ',
//       decimalDigits: 2,
//     ).format(val);
//   }
//
//   // Formats a simple number (e.g., 161.00 -> 161)
//   // IMPORTANT: This now accepts a num? for type safety.
// // Formats a simple number (e.g., 161.00 -> 161)
//   String _formatNumber(String? number) {
//     if (number == null) return 'N/A';
//     return number; // Removes decimal points
//   }
// // Formats a date (e.g., 15/05/2025)
//   String _formatDate(DateTime? dateTime) {
//     if (dateTime == null) return 'N/A';
//     return DateFormat('dd/MM/yyyy').format(dateTime);
//   }
// // C
//
//   // Converts month number to month name (e.g., 5 -> May)
//   String _formatMonthName(int? monthNumber) {
//     if (monthNumber == null || monthNumber < 1 || monthNumber > 12) return 'N/A';
//     return DateFormat.MMMM().format(DateTime(2000, monthNumber));
//   }
//
//   Widget _buildInfoCard(String title, String? value, {bool isNegativeRed = true}) {
//     final bool isNegative = value != null && value.contains('-');
//     final Color valueColor = isNegativeRed && isNegative ? Colors.red.shade700 : Colors.black87;
//
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 6),
//       elevation: 2,
//       color: ColorConstant.primaryWhite,
//       shadowColor: ColorConstant.primary.withOpacity(0.2),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Text(
//                 title,
//                 style: PMT.appStyle(
//                   size: 15,
//                   fontWeight: FontWeight.w500,
//                   fontColor: Colors.black54,
//                 ),
//               ),
//             ),
//             hBox(10),
//             Text(
//               value ?? 'N/A',
//               style: PMT.appStyle(
//                 size: 16,
//                 fontWeight: FontWeight.bold,
//                 fontColor: valueColor,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// lib/screens/your_feature/monthly_transaction_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/size_utils.dart';
import 'package:pg_managment/widgets/custom_elavated_button.dart';
import 'package:pg_managment/widgets/custom_image_view.dart';
import 'package:printing/printing.dart';
import 'controller/monthly_transaction_screen_controller.dart';
import 'package:pg_managment/widgets/custom_app_text_form_field.dart';

class MonthlyTransactionScreen
    extends GetWidget<MonthlyTransactionScreenController> {
  const MonthlyTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.primaryWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorConstant.primary,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomImageView(
                height: 40,
                width: 40,
                imagePath:  'assets/images/left-arrow.png' ,color: ColorConstant.primaryWhite),
          ),
        ),
        title: Text('Monthly Transaction', style: PMT.appStyle(size: 20, fontColor: ColorConstant.primaryWhite)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomAppTextFormField(
                      controller: controller.monthController,
                      onTap: () => controller.selectMonth(context),
                      readOnly: true,
                      variant: TextFormFieldVariant.OutlineGray200,
                      hintText: 'Select Month',
                    ),
                  ),
                  hBox(10),
                  Expanded(
                    child: CustomAppTextFormField(
                      controller: controller.yearController,
                      onTap: () => controller.selectYear(context),
                      readOnly: true,
                      variant: TextFormFieldVariant.OutlineGray200,
                      hintText: 'Select Year',
                    ),
                  ),
                  hBox(10),
                  TextButton(
                    onPressed: () => controller.getMonthlyTransaction(),
                    style: TextButton.styleFrom(
                      backgroundColor: ColorConstant.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('GO', style: PMT.appStyle(size: 16, fontWeight: FontWeight.bold, fontColor: ColorConstant.primaryWhite)),
                  ),
                ],
              ),
            ),
            hBox(10),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Using `!` because we handle the null case right below.
                final responseData = controller.monthlyTransactionList.value.data;

                if (responseData == null) {
                  return const Center(child: Text('No data found for the selected period.'));
                }

                // --- NEW: Perform calculations based on your requirements ---
                // NOTE: Assuming your data model has these fields. You may need to add them.
                // For example: studentDeposit and remarks might be new fields from your API.
                final currentExpense = _parseDouble(responseData.currentMonthExpense);
                final prevMonthGuest = _parseDouble(responseData.lastMonthTotalCashGuestAmount);
                final prevMonthCOH = _parseDouble(responseData.lastMonthTotalCaseOnHand);
                final prevMonthCollection = _parseDouble(responseData.lastMonthTotalCollection);
                final eatDays = _parseDouble(responseData.currentMonthTotalEatDay);

                // Assuming a new field 'studentDeposit' exists in your data model
                final studentDeposit = controller.totalDeposit.value;
                // final studentDeposit = _parseDouble( '0');

                final totalInflow = prevMonthGuest + prevMonthCOH + prevMonthCollection;
                final currentMonthCOH = totalInflow - currentExpense;
                final perDayExpense = (eatDays > 0) ? (currentExpense / eatDays) : 0.0;
                final profit = totalInflow - studentDeposit;

                // --- NEW: Report-style ListView ---
                return ListView(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  children: [
                    _buildTitle('Monthly Mess Transition'),
                    _buildSeparator(),

                    _buildDataRow(
                        '1.Year', responseData.year.toString(),
                        '2.Month', _formatMonthName(responseData.month)
                    ),
                    _buildSingleDataRow(
                        '3.Bill Date', _formatDate(DateTime(responseData.year ?? 2000, responseData.month ?? 1).add(Duration(days: -1)))
                    ),

                    const SizedBox(height: 8),

                    _buildDataRow(
                        '4.Total Days', _formatNumber(responseData.currentMonthTotalDay),
                        '5.Eaten Days', _formatNumber(responseData.currentMonthTotalEatDay)
                    ),
                    _buildSingleDataRow(
                        '6.Cut Days (sr. no 4 - 5)', _formatNumber(responseData.currentMonthTotalCutDay)
                    ),

                    _buildSeparator(),

                    _buildSingleDataRow('7.Current Month Expense', _formatCurrency(currentExpense)),
                    _buildSingleDataRow('8.Previous Month Cash Guest', _formatCurrency(prevMonthGuest)),
                    _buildSingleDataRow('9.Previous Month COH', _formatCurrency(prevMonthCOH)),
                    _buildSingleDataRow('10.Previous Month Collection', _formatCurrency(prevMonthCollection)),

                    _buildSeparator(),

                    _buildSingleDataRow('11.Total Inflow (sr. no 8 + 9 + 10)', _formatCurrency(totalInflow), isImportant: true),
                    _buildSingleDataRow('12.Current Month COH  (sr. no 11 - 7)', _formatCurrency(currentMonthCOH)),
                    _buildSingleDataRow('13.Cash Guest (Current)', _formatCurrency(_parseDouble(responseData.currentMonthTotalGuestAmount))),
                    _buildSingleDataRow('14.Per Day Expense (sr. no 7 / 6) ', _formatCurrency(perDayExpense, decimalDigits: 2)),
                    _buildSingleDataRow('15.Deposit (Students)', _formatCurrency(studentDeposit)),

                    _buildSeparator(),

                    _buildSingleDataRow('16.Surplus Amount (sr. no 11 - 15)', _formatCurrency(profit), isImportant: true),
                    _buildSingleDataRow('17.Current Month Total Collection', _formatCurrency(double.parse(responseData.currentTotalCollection??'0.0')), isImportant: true),
                    _buildSingleDataRow('18.Current Month Total Remaining', _formatCurrency(double.parse(responseData.currentTotalRemaining??'0.0')), isImportant: true),

                    // NOTE: Assuming a 'remarks' field exists in your data model
                    // _buildRemarks(responseData.remarks),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 5),
        child: AppElevatedButton(
          buttonName: 'Download PDF',
          onPressed: () async {
            if (controller.monthlyTransactionList.value.data == null) {
              Get.snackbar("Notice", "No data available to download.",
                  snackPosition: SnackPosition.BOTTOM);
              return;
            }
            final pdfData = await controller.generatePdf();
            await Printing.sharePdf(
              bytes: pdfData,
              filename: 'Monthly_Report_${controller.yearController.text}_${controller.monthController.text}.pdf',
            );
          },
        ),
      ),
    );
  }

  // --- NEW: Helper Widgets for Report Layout ---

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: PMT.appStyle(size: 20, fontWeight: FontWeight.bold, fontColor: ColorConstant.primary),
      ),
    );
  }

  Widget _buildSeparator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(color: Colors.black26),
    );
  }

  Widget _buildDataRow(String label1, String value1, String label2, String value2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLabelValueRichText(label1, value1),
          _buildLabelValueRichText(label2, value2),
        ],
      ),
    );
  }

  Widget _buildSingleDataRow(String label, String value, {bool isImportant = false}) {
    final isNegative = value.contains('-');
    final valueColor = isNegative ? Colors.red.shade700 : (isImportant ? ColorConstant.primary : Colors.black87);
    final valueWeight = isImportant ? FontWeight.bold : FontWeight.w600;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(

              child: Text('$label:', style: PMT.appStyle(size: 15, fontColor: Colors.black54))),
          Text(
            value,
            style: PMT.appStyle(size: 15, fontWeight: valueWeight, fontColor: valueColor),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelValueRichText(String label, String value) {
    return Text.rich(
      TextSpan(
        text: '$label: ',
        style: PMT.appStyle(size: 15, fontColor: Colors.black54),
        children: [
          TextSpan(
            text: value,
            style: PMT.appStyle(size: 15, fontWeight: FontWeight.w600, fontColor: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildRemarks(String? remarks) {
    if (remarks == null || remarks.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Text(
        "Remarks: $remarks",
        style: PMT.appStyle(size: 14, fontColor: Colors.black54),
      ),
    );
  }

  // --- Helper Functions for Formatting & Calculation ---

  double _parseDouble(String? value) {
    if (value == null) return 0.0;
    return double.tryParse(value) ?? 0.0;
  }

  String _formatCurrency(double? value, {int decimalDigits = 0}) {
    if (value == null) return 'N/A';
    return NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹ ',
      decimalDigits: decimalDigits,
    ).format(value);
  }

  String _formatNumber(String? number) {
    if (number == null) return 'N/A';
    final numValue = double.tryParse(number);
    return numValue != null ? numValue.toInt().toString() : number;
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  String _formatMonthName(int? monthNumber) {
    if (monthNumber == null || monthNumber < 1 || monthNumber > 12) return 'N/A';
    return DateFormat.MMMM().format(DateTime(2000, monthNumber));
  }
}