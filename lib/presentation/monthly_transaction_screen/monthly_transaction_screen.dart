import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/size_utils.dart';
import 'package:pg_managment/widgets/custom_elavated_button.dart';
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
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: ColorConstant.primaryWhite,
          ),
        ),
        title: Text(
          'Monthly Transaction',
          style: PMT.appStyle(
            size: 20,
            fontColor: ColorConstant.primaryWhite,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomAppTextFormField(
                    controller: controller.monthController,
                    onTap: () {
                      controller.selectMonth(context);
                    },
                    readOnly: true,
                    variant: TextFormFieldVariant.OutlineGray200,
                    hintText: 'Select Month',
                  ),
                ),
                hBox(10),
                Expanded(
                  child: CustomAppTextFormField(
                    controller: controller.yearController,
                    onTap: () {
                      controller.selectYear(context);
                    },
                    readOnly: true,
                    variant: TextFormFieldVariant.OutlineGray200,
                    hintText: 'Select Year',
                  ),
                ),
                hBox(10),
                TextButton(
                  onPressed: () {
                    controller.getMonthlyTransaction();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: ColorConstant.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  child: Text(
                    'GO',
                    style: PMT.appStyle(
                      size: 16,
                      fontWeight: FontWeight.bold,
                      fontColor: ColorConstant.primaryWhite,
                    ),
                  ),
                ),
              ],
            ),
            hBox(16),
            Expanded(
              child: Obx(() {
                var data = controller.monthlyTransactionList.value.data;
                return controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : data == null
                        ? const Center(child: Text('No data found'))
                        : ListView(
                            padding: const EdgeInsets.only(bottom: 20),
                            children: [
                              _buildInfoCard('Bill Date', _formatDate(data.billDate)),
                              _buildInfoCard('Year', data.year?.toString()),
                              _buildInfoCard('Month', data.month?.toString()),
                              _buildInfoCard('Current Month Expense', data.currentMonthExpense),
                              _buildInfoCard('Total Guest Amount', data.currentMonthTotalGuestAmount),
                              _buildInfoCard('Total Cash On Hand', data.currentMonthTotalCashOnHand),
                              _buildInfoCard('Total Collection', data.currentTotalCollection),
                              _buildInfoCard('Total Amount', data.currentMonthTotalAmount),
                              _buildInfoCard('Remaining Amount', data.currentTotalRemaining),
                              _buildInfoCard('Eat Days', data.currentMonthTotalEatDay),
                              _buildInfoCard('Cut Days', data.currentMonthTotalCutDay),
                              _buildInfoCard('Total Days', data.currentMonthTotalDay),
                              _buildInfoCard('Profit', data.currentMonthProfit),
                            ],
                          );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16,right: 16,bottom: 10),
        child: AppElevatedButton(
          buttonName: 'Download PDF',
          onPressed: () async {
            final pdfData = await controller.generatePdf();
            await Printing.sharePdf(
              bytes: pdfData,

              filename: 'Expanse Repost ${DateTime.now()}.pdf',
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String? value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      color: ColorConstant.primaryWhite,
      shadowColor: ColorConstant.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          title,
          style: PMT.appStyle(
            size: 16,
            fontWeight: FontWeight.bold,
            fontColor: ColorConstant.primary,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            value ?? 'N/A',
            style: PMT.appStyle(
              size: 15,
              fontWeight: FontWeight.w500,
              fontColor: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
