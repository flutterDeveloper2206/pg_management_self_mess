

import 'dart:io';

import 'package:excel/excel.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pg_managment/ApiServices/api_service.dart';
import 'package:pg_managment/core/utils/app_network_urls.dart';
import 'package:pg_managment/presentation/student_list_screen/student_list_model.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
class DepositDetailsScreenController extends GetxController {


RxBool isLoading = false.obs;
Rx<StudentListModel> studentListModel = StudentListModel().obs;
RxList<List<String>> depositDetailList = <List<String>>[].obs;
RxList<List<TextCellValue>> studentMonthlyStudentListForExel = <List<TextCellValue>>[].obs;

RxDouble totalDeposit = 0.0.obs;
@override
void onInit() {
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    getStudentList();
  });
  super.onInit();
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
      studentListModel.value = StudentListModel.fromJson(value.body);
      if(studentListModel.value.data!=null &&studentListModel.value.data!.isNotEmpty) {
        depositDetailList.value=  generateStudentTableList(studentListModel.value)??[];
        studentMonthlyStudentListForExel.value =
            generateStudentTableListExel(studentListModel.value)?.reversed.toList() ?? [];
        studentListModel.value.data!.forEach((element) {
          totalDeposit.value = totalDeposit.value+element.deposit!.toDouble()??0.0;

      },);
      }
    }
  });
}

List<List<String>>? generateStudentTableList(StudentListModel model) {
  return model.data?.asMap().entries.map((entry) {
    final student = entry.value;
    return [
      '${student.id??0}',
      student.name ?? '',
      student.deposit?.toString() ?? '0',
      student.date ?? '0',


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
        pw.Text('Student Deposit Report',
            style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 16),
        pw.Text('Date: ${DateTime.now().toLocal()}'),
        pw.SizedBox(height: 16),
        pw.Text('This is a  PDF report with student Deposit data.'),
        pw.SizedBox(height: 20),
        pw.Table.fromTextArray(
          headers: ['ID', 'Name', 'Deposit','Date'],
          data: depositDetailList,
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
  var sheet = excel['Student Deposit'];

  // 2️⃣ Add some data
  sheet.appendRow([
    TextCellValue('Student ID'),
    TextCellValue('Student Name'),
    TextCellValue('Deposit'),
    TextCellValue('Date'),

  ]);
  for(var item in studentMonthlyStudentListForExel){

    sheet.appendRow(item);
  }

  // 3️⃣ Encode to bytes
  final excelBytes = excel.encode();

  // 4️⃣ Save temporarily (app's documents directory)
  final directory = await getTemporaryDirectory();
  final filePath = '${directory.path}/StudentDeposit_excel${DateTime.now().toIso8601String()}.xlsx';
  final file = File(filePath);
  await file.writeAsBytes(excelBytes!);

  // 5️⃣ Share the file
  await Share.shareXFiles([XFile(filePath)],
      text: '📊 Check out this Excel file');
}
List<List<TextCellValue>>? generateStudentTableListExel(StudentListModel model) {
  return model.data?.asMap().entries.map((entry) {
    final student = entry.value;
    return [
      TextCellValue('${student.id}'),
      TextCellValue('${student.name ?? ' '}'),
      TextCellValue('${student.deposit ?? '0'}'),
      TextCellValue('${student.date ?? '0'}'),

    ];
  }).toList() ??
      [];
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

                  filename: 'deposit Repost ${DateTime.now()}.pdf',
                );                },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart, color: Colors.green),
              title: const Text('Download Excel'),
              onTap: () {
                Navigator.pop(context);
                createAndShareExcel();                },
            ),
          ],
        ),
      );
    },
  );
}


}
