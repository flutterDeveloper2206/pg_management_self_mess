import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pg_managment/core/utils/app_network_urls.dart';
import 'package:pg_managment/core/utils/navigation_service.dart';
import 'package:pg_managment/core/utils/progress_dialog_utils.dart';
import 'package:pg_managment/presentation/all_details_list_screen/all_details_list_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../../../ApiServices/api_service.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'package:excel/excel.dart';
import 'package:pg_managment/widgets/month_year_picker.dart';

class AllDetailsListScreenController extends GetxController {
  RxBool isLoading = false.obs;
  RxDouble totalCollection = 0.0.obs;
  RxDouble totalRemaining = 0.0.obs;
  RxInt totalMealDay = 0.obs;
  RxInt totalCutDay = 0.obs;
  Rx<StudentAllDetailsModel> allStudentListModel = StudentAllDetailsModel().obs;
  TextEditingController month = TextEditingController();
  TextEditingController year = TextEditingController();
  RxList<List<String>> studentMonthlyStudentList = <List<String>>[].obs;
  RxList<List<TextCellValue>> studentMonthlyStudentListForExel =
      <List<TextCellValue>>[].obs;
  RxList<AllData> studentListSearch = <AllData>[].obs;

  @override
  void onInit() {
    month.text = DateTime.now().month.toString().padLeft(2, '0');
    year.text = DateTime.now().year.toString();
    getAllStudentDetails(month: month.text, year: year.text);
    super.onInit();
  }

  Future searchStudent(String search) async {
    if (search.isEmpty) {
      studentListSearch.value = allStudentListModel.value.data ?? [];
    } else {
      studentListSearch.value = allStudentListModel.value.data
              ?.where((element) =>
                  element.studentName!.toLowerCase().contains(search) ||
                  element.studentId!.toString().toLowerCase().contains(search))
              .toList() ??
          [];
    }
    update();
  }

  Future<void> selectMonth(BuildContext context) async {
    final DateTime? picked = await MonthYearPicker.show(context,
        initialDate: DateTime(int.parse(year.text), int.parse(month.text)));

    if (picked != null) {
      month.text = picked.month.toString().padLeft(2, '0');
      year.text = picked.year.toString();
      getAllStudentDetails(month: month.text, year: year.text);
    }
  }

  Future<void> selectYear(BuildContext context) async {
    final DateTime? picked = await MonthYearPicker.show(context,
        initialDate: DateTime(int.parse(year.text), int.parse(month.text)));

    if (picked != null) {
      month.text = picked.month.toString().padLeft(2, '0');
      year.text = picked.year.toString();
    }
    getAllStudentDetails(month: month.text, year: year.text);
  }

  Future<void> getAllStudentDetails({String? month, String? year}) async {
    isLoading.value = true;

    await ApiService().callGetApi(
        body: {},
        headerWithToken: true,
        showLoader: false,
        url:
            '${NetworkUrls.dayDetailsListUrl}month=$month&year=$year').then(
        (value) async {
      isLoading.value = false;
      if (value != null && value.statusCode == 200) {
        isLoading.value = false;
        allStudentListModel.value = StudentAllDetailsModel.fromJson(value.body);
        if (allStudentListModel.value.data != null &&
            allStudentListModel.value.data!.isNotEmpty) {
          totalCollection.value = 0.0;
          totalRemaining.value = 0.0;
          totalMealDay.value = 0;
          totalCutDay.value = 0;
          studentMonthlyStudentList.value =
              generateStudentTableList(allStudentListModel.value) ?? [];
          studentMonthlyStudentListForExel.value =
              generateStudentTableListExel(allStudentListModel.value)
                      ?.reversed
                      .toList() ??
                  [];
          studentListSearch.value = allStudentListModel.value.data ?? [];

          allStudentListModel.value.data?.forEach(
            (element) {
              totalCollection.value = totalCollection.value +
                      (element.paidAmount ?? 0).toDouble() ??
                  0.0;
              totalRemaining.value = totalRemaining.value +
                      (element.remainAmount ?? 0).toDouble() ??
                  0.0;
              totalMealDay.value =
                  totalMealDay.value + (element.totalDay ?? 0) ?? 0;
              totalCutDay.value =
                  totalCutDay.value + (element.cutDay ?? 0) ?? 0;
            },
          );
        }
      }
    });
  }

  List<List<String>>? generateStudentTableList(StudentAllDetailsModel model) {
    return model.data?.asMap().entries.map((entry) {
          final student = entry.value;
          return [
            '${student.studentId}',
            '${student.studentName ?? ' '}',
            '${student.totalDay?.toString() ?? '0'}',
            '${student.totalEatDay ?? '0'}',
            '${student.cutDay ?? '0'}',
            '${student.simpleGuest ?? '0'}',
            '${student.feastGuest ?? '0'}',
            '${student.rate ?? '0'}',
            '${student.penaltyAmount ?? '0'}',
            '${student.paidAmount ?? '0'}',
            '${student.totalAmount ?? '0'}',
          ];
        }).toList() ??
        [];
  }

  List<List<TextCellValue>>? generateStudentTableListExel(
      StudentAllDetailsModel model) {
    return model.data?.asMap().entries.map((entry) {
          final student = entry.value;
          return [
            TextCellValue('${student.studentId}'),
            TextCellValue('${student.studentName ?? ' '}'),
            TextCellValue('${student.totalDay?.toString() ?? '0'}'),
            TextCellValue('${student.totalEatDay ?? '0'}'),
            TextCellValue('${student.cutDay ?? '0'}'),
            TextCellValue('${student.simpleGuest ?? '0'}'),
            TextCellValue('${student.simpleGuestAmount ?? '0'}'),
            TextCellValue('${student.feastGuest ?? '0'}'),
            TextCellValue('${student.feastGuestAmount ?? '0'}'),
            TextCellValue('${student.rate ?? '0'}'),
            TextCellValue('${student.penaltyAmount ?? '0'}'),
            TextCellValue('${student.dueAmount ?? '0'}'),
            TextCellValue('${student.remainAmount ?? '0'}'),
            TextCellValue('${student.paidAmount ?? '0'}'),
            TextCellValue('${student.totalAmount ?? '0'}'),
            TextCellValue('${student.amount ?? '0'}'),
            TextCellValue('${student.remark ?? ''}'),
          ];
        }).toList() ??
        [];
  }

  Future<Uint8List> generatePdf() async {
    final pdf = pw.Document();

    // Load optional image from assets
    final ByteData logoBytes =
        await rootBundle.load('assets/images/ic_launcher.png');
    final Uint8List logoUint8List = logoBytes.buffer.asUint8List();
    final image = pw.MemoryImage(logoUint8List);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Center(child: pw.Image(image, width: 100)), // Optional logo
          pw.SizedBox(height: 20),
          pw.Text('Student Monthly Report',
              style:
                  pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 16),
          pw.Text('Date: ${DateTime.now().toLocal()}'),
          pw.SizedBox(height: 16),
          pw.Text('This is a  PDF report with All Student Monthly data.'),
          pw.SizedBox(height: 16),

          pw.Text('Total Collection : ${totalCollection.value}'),
          pw.SizedBox(height: 16),
          pw.Text('Total Remaining : ${totalRemaining.value}'),
          pw.Divider(),
          pw.Text('Total MealDay : ${totalMealDay.value}'),
          pw.SizedBox(height: 16),
          pw.Text('Total CutDay : ${totalCutDay.value}'),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: [
              'Student ID',
              'Student Name',
              'Total Day',
              'Total Eat Day',
              'Cut Day',
              'Simple Guest',
              'Feast Guest',
              'Rate',
              'Penalty Amount',
              'Paid Amount',
              'Total Amount'
            ],
            data: studentMonthlyStudentList,
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

  Future<void> createAndShareExcel() async {
    // 1️⃣ Create Excel
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];

    // 2️⃣ Add some data
    sheet.appendRow([
      TextCellValue('Student ID'),
      TextCellValue('Student Name'),
      TextCellValue('Total Day'),
      TextCellValue('Total Eat Day'),
      TextCellValue('Cut Day'),
      TextCellValue('Simple Guest'),
      TextCellValue('Simple Guest Amount'),
      TextCellValue('Feast Guest'),
      TextCellValue('Feast Guest Amount'),
      TextCellValue('Rate'),
      TextCellValue('Penalty Amount'),
      TextCellValue('Due Amount'),
      TextCellValue('Remain Amount'),
      TextCellValue('Paid Amount'),
      TextCellValue('Total Amount'),
      TextCellValue('Amount'),
      TextCellValue('Remark')
    ]);
    for (var item in studentMonthlyStudentListForExel) {
      sheet.appendRow(item);
    }

    // 3️⃣ Encode to bytes
    final excelBytes = excel.encode();

    // 4️⃣ Save temporarily (app's documents directory)
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/shared_excel.xlsx';
    final file = File(filePath);
    await file.writeAsBytes(excelBytes!);

    // 5️⃣ Share the file
    await Share.shareXFiles([XFile(filePath)],
        text: '📊 Check out this Excel file');
  }

  void showDownloadSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const Text(
                'Choose Download Option',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                title: const Text('Download PDF'),
                onTap: () async {
                  Navigator.pop(context);
                  final pdfData = await generatePdf();
                  await Printing.sharePdf(
                    bytes: pdfData,
                    filename: 'Expanse Repost ${DateTime.now()}.pdf',
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.table_chart, color: Colors.green),
                title: const Text('Download Excel'),
                onTap: () {
                  Navigator.pop(context);
                  createAndShareExcel();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
