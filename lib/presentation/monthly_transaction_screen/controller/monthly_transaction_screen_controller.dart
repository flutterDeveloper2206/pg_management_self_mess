import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
import 'package:pg_managment/presentation/student_list_screen/student_list_model.dart'as s;

class MonthlyTransactionScreenController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<MonthlyTransactionModel> monthlyTransactionList =
      MonthlyTransactionModel().obs;
  RxDouble totalDeposit = 0.0.obs;
  Rx<s.StudentListModel> studentListModel = s.StudentListModel().obs;

  TextEditingController yearController = TextEditingController();
  TextEditingController monthController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    yearController.text = DateTime.now().year.toString();
    monthController.text = DateTime.now().month.toString();
    getMonthlyTransaction();
    getStudentList();
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



  Future getStudentList() async {
    isLoading.value = true;

    await ApiService().callGetApi(
        body: {},
        headerWithToken: true,
        showLoader: false,
        url: NetworkUrls.studentListUrl).then((value) async {
      isLoading.value = false;
      if (value != null && value.statusCode == 200) {
        studentListModel.value = s.StudentListModel.fromJson(value.body);
        if(studentListModel.value.data!=null &&studentListModel.value.data!.isNotEmpty) {
          studentListModel.value.data!.forEach((element) {
            totalDeposit.value = totalDeposit.value+element.deposit!.toDouble()??0.0;
          },);
        }
      }
    });
  }

  // Future<Uint8List> generatePdf() async {
  //   final pdf = pw.Document();
  //   Data data = monthlyTransactionList.value.data!;
  //   // Load optional image from assets
  //   final ByteData logoBytes = await rootBundle.load('assets/images/ic_launcher.png');
  //   final Uint8List logoUint8List = logoBytes.buffer.asUint8List();
  //   final image = pw.MemoryImage(logoUint8List);
  //
  //   pdf.addPage(
  //     pw.MultiPage(
  //       pageFormat: PdfPageFormat.a4,
  //       build: (context) => [
  //         pw.Center(child: pw.Image(image, width: 100)), // Optional logo
  //         pw.SizedBox(height: 20),
  //         pw.Text('Monthly Transaction Report',
  //             style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold)),
  //         pw.SizedBox(height: 16),
  //         pw.Text('Date: ${DateTime.now().toLocal()}'),
  //         pw.SizedBox(height: 16),
  //         pw.Text('This is a  PDF report with Monthly Transaction data.'),
  //         pw.SizedBox(height: 20),
  //         pw.Divider(),
  //         pw.SizedBox(height: 20),
  //         _buildInfoCard('Bill Date', _formatDate(data.billDate)),
  //         pw.Row(
  //             mainAxisAlignment:pw. MainAxisAlignment.spaceBetween,
  //             children: [_buildInfoCard('Month', data.month?.toString()), _buildInfoCard('Year', data.year?.toString()),]),
  //
  //
  //         _buildInfoCard('Current Month Expense', data.currentMonthExpense),
  //         _buildInfoCard('Total Guest Amount', data.currentMonthTotalGuestAmount),
  //         _buildInfoCard('Total Cash On Hand', data.currentMonthTotalCashOnHand),
  //         _buildInfoCard('Total Collection', data.currentTotalCollection),
  //         _buildInfoCard('Total Amount', data.currentMonthTotalAmount),
  //         _buildInfoCard('Remaining Amount', data.currentTotalRemaining),
  //         _buildInfoCard('Eat Days', data.currentMonthTotalEatDay),
  //         _buildInfoCard('Cut Days', data.currentMonthTotalCutDay),
  //         _buildInfoCard('Total Days', data.currentMonthTotalDay),
  //         _buildInfoCard('Profit', data.currentMonthProfit),
  //         _buildInfoCard('Last Month Total Collection', (data.lastMonthTotalCollection.toString())),
  //         _buildInfoCard('Last Month Cash On Hand', (data.lastMonthTotalCaseOnHand.toString())),
  //         _buildInfoCard('Last Month Guest Amount', (data.lastMonthTotalCashGuestAmount.toString())),
  //         _buildInfoCard('Last Month Total Amount', (data.lastMonthTotalAmount.toString())),
  //
  //       ],
  //     ),
  //   );
  //
  //   return pdf.save();
  // }
  // String _formatDate(DateTime? dateTime) {
  //   if (dateTime == null) return 'N/A';
  //   return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  // }
  // pw.Widget _buildInfoCard(String title, String? value) {
  //   return pw.Container(
  //     margin: const pw.EdgeInsets.symmetric(vertical: 8),
  //     decoration: pw.BoxDecoration(
  //     color: PdfColors.white,
  //
  //     ),
  //
  //     child: pw.Row(
  //       children: [
  //       pw.Text(
  //       '${title} :-',
  //       style:pw.TextStyle(
  //         fontSize: 16,
  //         fontWeight: pw.FontWeight.bold,
  //           color: PdfColor.fromInt(0xFF009999)
  //       )),
  //         pw.SizedBox(
  //           width: 10
  //         ),
  //         pw.Text(
  //             value ?? 'N/A',
  //       style:pw.TextStyle(
  //         fontSize: 15,
  //         fontWeight: pw.FontWeight.normal,
  //           color: PdfColor.fromInt(0xDD000000)
  //       ))
  //       ],
  //
  //     ),
  //   );
  // }
  //

  Future<Uint8List> generatePdf() async {
      Data data = monthlyTransactionList.value.data!;

    final pdf = pw.Document();
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    final currencyFormatDecimal = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);
      final font = pw.Font.ttf(
        await rootBundle.load("assets/fonts/Inter_28pt-Regular.ttf"),
      );
    // --- Helper functions for safe parsing and calculation ---
    double p(String? s) => double.tryParse(s ?? '0') ?? 0;

    final totalEatenDays = p(data.currentMonthTotalEatDay);
    final currentMonthExpense = p(data.currentMonthExpense);
    final prevMonthCashGuest = p(data.lastMonthTotalCashGuestAmount);
    final prevMonthCOH = p(data.lastMonthTotalCaseOnHand);
    final prevMonthCollection = p(data.lastMonthTotalCollection);

    // --- Calculations from your provided logic ---
    final totalInflow = prevMonthCashGuest + prevMonthCOH + prevMonthCollection;
    final currentMonthCOH = totalInflow - currentMonthExpense;
    final perDayExpense = totalEatenDays > 0 ? currentMonthExpense / totalEatenDays : 0;
    final profit = totalInflow - totalDeposit.value; // Using the new 'studentDeposit' field


    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // 1. Title Section
              _buildTitle(font),
              pw.SizedBox(height: 20),

              // 2. Header Info
              _buildHeaderInfo(data),
              pw.SizedBox(height: 20),
              pw.Divider(thickness: 1.5),

              // 3. Days Info (Two Columns)
              pw.Row(
                children: [
                  pw.Expanded(
                    child: _buildKeyValue('4.Total Days', data.currentMonthTotalDay ?? '0',  valueStyle: pw.TextStyle(font: font,),),
                  ),
                  pw.SizedBox(width: 20),
                  pw.Expanded(
                    child: pw.Column(
                      children: [
                        _buildKeyValue('5.Eaten Days', data.currentMonthTotalEatDay ?? '0',  valueStyle: pw.TextStyle(font: font,),),
                        _buildKeyValue('6.Cut Days (sr. no 4 - 5)', data.currentMonthTotalCutDay ?? '0',  valueStyle: pw.TextStyle(font: font,),),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 15),


              // 4. Main Financial Details
              _buildKeyValue('7.Current Month Expense', currencyFormat.format(currentMonthExpense),  valueStyle: pw.TextStyle(font: font,),),
              _buildKeyValue('8.Previous Month Cash Guest', currencyFormat.format(prevMonthCashGuest),  valueStyle: pw.TextStyle(font: font,),),
              _buildKeyValue('9.Previous Month COH', currencyFormat.format(prevMonthCOH),  valueStyle: pw.TextStyle(font: font,),),
              _buildKeyValue('10.Previous Month Collection', currencyFormat.format(prevMonthCollection),  valueStyle: pw.TextStyle(font: font,),),

              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 8),
                child: pw.Divider(),
              ),

              _buildKeyValue('11.Total Inflow (sr. no 8 + 9 + 10)', currencyFormat.format(totalInflow),  valueStyle: pw.TextStyle(font: font,),),
              _buildKeyValue('12.Current Month COH  (sr. no 11 - 7)', currencyFormat.format(currentMonthCOH),  valueStyle: pw.TextStyle(font: font,),),
              _buildKeyValue('13.Cash Guest (Current)', currencyFormat.format(p(data.currentMonthTotalGuestAmount)),  valueStyle: pw.TextStyle(font: font,),),
              _buildKeyValue('14.Per Day Expense (sr. no 7 / 6) ', currencyFormatDecimal.format(perDayExpense),  valueStyle: pw.TextStyle(font: font,),),
              _buildKeyValue('15.Deposit (Students)', currencyFormat.format(totalDeposit.value),  valueStyle: pw.TextStyle(font: font,),),
              pw.SizedBox(height: 15),
              pw.Divider(thickness: 1.5),

              // 5. Profit (with red color for negative values)
              _buildKeyValue(
                '16.Profit  (sr. no 11 - 15)',
                currencyFormat.format(profit),
                valueStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  font: font,
                  color: profit < 0 ? PdfColors.red : PdfColors.black,
                ),
              ),

              pw.Spacer(), // Pushes the remarks to the bottom

              // 6. Remarks Section

            ],
          );
        },
      ),
    );

    return pdf.save();
  }

// --- Helper Widgets ---

  pw.Widget _buildTitle(font) {
    return pw.Column(
      children: [
        pw.Divider(thickness: 1.5),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 4),
          child: pw.Text(
            'Monthly Mess Transition',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold,font: font),
          ),
        ),
        pw.Divider(thickness: 1.5),
      ],
    );
  }

  pw.Widget _buildHeaderInfo(Data data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('1.Year: ${data.year ?? 'N/A'}'),
            pw.Text('2.Month:  ${_getMonthName(data.month ?? 0)}'),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Text('3.Bill Date: ${_formatDate(data.billDate)}'),
      ],
    );
  }

  pw.Widget _buildKeyValue(String key, String value, {pw.TextStyle? valueStyle,}) {

    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3.0),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(key + ':', style: pw.TextStyle(fontWeight: pw.FontWeight.bold,)),
          pw.Text(value, style: valueStyle),
        ],
      ),
    );
  }

// --- Helper Functions ---

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    if (month >= 1 && month <= 12) {
      return monthNames[month - 1];
    }
    return 'N/A';
  }

}
