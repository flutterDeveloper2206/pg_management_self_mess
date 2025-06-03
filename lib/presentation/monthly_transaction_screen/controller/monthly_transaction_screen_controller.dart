import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'package:pg_managment/ApiServices/api_service.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/app_network_urls.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/navigation_service.dart';
import 'package:pg_managment/core/utils/progress_dialog_utils.dart';
import 'package:pg_managment/presentation/monthly_transaction_screen/transaction_model.dart';

class MonthlyTransactionScreenController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<MonthlyTransactionModel> monthlyTransactionList =
      MonthlyTransactionModel().obs;

  TextEditingController yearController = TextEditingController();
  TextEditingController monthController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    yearController.text = DateTime.now().year.toString();
    monthController.text = DateTime.now().month.toString();
    getMonthlyTransaction();
  }

  Future<void> selectMonth(BuildContext context) async {
    print('object');
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDatePickerMode: DatePickerMode.day,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2090),
    );

    if (picked != null) {
      String formattedDate = picked.month.toString().padLeft(2, '0');
      monthController.text = formattedDate;
    }
  }

  Future<void> selectYear(BuildContext context) async {
    print('object');
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDatePickerMode: DatePickerMode.year,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2090),
    );

    if (picked != null) {
      String formattedDate = "${picked.year.toString()}";
      yearController.text = formattedDate;
    }
  }

  Future<void> getMonthlyTransaction() async {
    if (yearController.text.isEmpty || monthController.text.isEmpty) {
      AppFlushBars.appCommonFlushBar(
          context: NavigationService.navigatorKey.currentContext!,
          message: 'Please enter both year and month',
          success: false);
      return;
    }
    isLoading.value = true;

    await ApiService().callPostApi(
        body: {"year": yearController.text, "month": monthController.text},
        url: NetworkUrls.monthlyTransactionUrl,
        headerWithToken: true,
        showLoader: false).then((value) async {
      isLoading.value = false;
      if (value != null && value.statusCode == 200) {
        monthlyTransactionList.value =
            MonthlyTransactionModel.fromJson(value.body);
        isLoading.value = false;
      } else {
        isLoading.value = false;
        monthlyTransactionList.value = MonthlyTransactionModel();
      }
    });
  }
  Future<Uint8List> generatePdf() async {
    final pdf = pw.Document();
    Data data = monthlyTransactionList.value.data!;
    // Load optional image from assets
    final ByteData logoBytes = await rootBundle.load('assets/images/ic_launcher.png');
    final Uint8List logoUint8List = logoBytes.buffer.asUint8List();
    final image = pw.MemoryImage(logoUint8List);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Center(child: pw.Image(image, width: 100)), // Optional logo
          pw.SizedBox(height: 20),
          pw.Text('Monthly Transaction Report',
              style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 16),
          pw.Text('Date: ${DateTime.now().toLocal()}'),
          pw.SizedBox(height: 16),
          pw.Text('This is a  PDF report with Monthly Transaction data.'),
          pw.SizedBox(height: 20),
          pw.Divider(),
          pw.SizedBox(height: 20),
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
      ),
    );

    return pdf.save();
  }
  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
  pw.Widget _buildInfoCard(String title, String? value) {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(vertical: 8),
      decoration: pw.BoxDecoration(
      color: PdfColors.white,

      ),

      child: pw.Row(
        children: [
        pw.Text(
        '${title} :-',
        style:pw.TextStyle(
          fontSize: 16,
          fontWeight: pw.FontWeight.bold,
            color: PdfColor.fromInt(0xFF009999)
        )),
          pw.SizedBox(
            width: 10
          ),
          pw.Text(
              value ?? 'N/A',
        style:pw.TextStyle(
          fontSize: 15,
          fontWeight: pw.FontWeight.normal,
            color: PdfColor.fromInt(0xDD000000)
        ))
        ],

      ),
    );
  }



}
