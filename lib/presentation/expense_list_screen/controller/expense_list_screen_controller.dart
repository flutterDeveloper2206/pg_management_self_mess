
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pg_managment/core/utils/app_network_urls.dart';

import 'package:pg_managment/presentation/expense_list_screen/expense_list_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import '../../../ApiServices/api_service.dart';
import '../../../core/utils/color_constant.dart';

class ExpenseListScreenController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<ExpenseListModel> expenseListModel = ExpenseListModel().obs;
  RxList<List<String>> expanseDetailList = <List<String>>[].obs;

  RxDouble totalExpanse = 0.0.obs;
  TextEditingController month = TextEditingController();
  TextEditingController year = TextEditingController();
  @override
  void onInit() {
    month.text = DateTime.now().month.toString().padLeft(2, '0');
    year.text = DateTime.now().year.toString();
    getExpenseList(
        month: '${DateTime.now().month}', year: '${DateTime.now().year}');
    super.onInit();
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
      month.text = formattedDate;
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
      year.text = formattedDate;
    }
  }

  getExpenseList({String? month, String? year}) async {
    isLoading.value = true;

    await ApiService().callGetApi(
        body: {},
        headerWithToken: true,
        showLoader: false,
        url:
            '${NetworkUrls.expenseListUrl}month=$month&year=$year').then(
        (value) async {
      isLoading.value = false;
      if (value != null && value.statusCode == 200) {
        expenseListModel.value = ExpenseListModel.fromJson(value.body);
        totalExpanse.value=0.0;
        if(expenseListModel.value.data!=null &&expenseListModel.value.data!.isNotEmpty) {

          expanseDetailList.value=  generateStudentTableList(expenseListModel.value)??[];

        for (var expense in expenseListModel.value.data!) {

          totalExpanse.value += expense?.amount?? 0;

        }}
      }
    });
  }

  Future<void> deleteExpense({String? id}) async {
    isLoading.value = true;

    await ApiService().callDeleteApi(
        body: {},
        headerWithToken: true,
        showLoader: false,
        url: NetworkUrls.expenseDeleteUrl + id.toString()).then((value) async {
      isLoading.value = false;

      if (value != null && value.statusCode == 200) {
        getExpenseList(
            month: '${DateTime.now().month}', year: '${DateTime.now().year}');
      }
    });
  }
  void showDeleteConfirmationDialog(BuildContext context, VoidCallback onYesPressed) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this expanse?"),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          actionsAlignment: MainAxisAlignment.end,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("No",style: TextStyle(color: Colors.black),),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onYesPressed(); // Callback for yes
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.primary,
              ),
              child: Text("Yes",style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
  }


  List<List<String>>? generateStudentTableList(ExpenseListModel model) {
    return model.data?.asMap().entries.map((entry) {
      final student = entry.value;
      return [
        '${entry.key+1}',
        '${student.item ?? ' '}',
        '${student.amount?.toString() ?? '0'}',
        '${student.date ?? '0'}',


      ];
    }).toList() ?? [];
  }
  Future<Uint8List> generatePdf() async {
    final pdf = pw.Document();

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
          pw.Text('Expense Report',
              style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 16),
          pw.Text('Date: ${DateTime.now().toLocal()}'),
          pw.SizedBox(height: 16),
          pw.Text('This is a  PDF report with All Expense data.'),
          pw.SizedBox(height: 20),
          pw.Text('Total Expense :- ${totalExpanse}'),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: ['ID', 'Expense Name (Item)', 'Amount','Date'],
            data: expanseDetailList,
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellStyle: pw.TextStyle(fontSize: 12),
            cellAlignment: pw.Alignment.center,
            border: pw.TableBorder.all(color: PdfColors.grey),
          ),
        ],
      ),
    );

    return pdf.save();
  }

}
