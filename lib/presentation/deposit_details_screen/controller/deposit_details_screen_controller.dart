

import 'package:get/get.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pg_managment/ApiServices/api_service.dart';
import 'package:pg_managment/core/utils/app_network_urls.dart';
import 'package:pg_managment/presentation/student_list_screen/student_list_model.dart';
import 'package:flutter/services.dart' show rootBundle;
class DepositDetailsScreenController extends GetxController {


RxBool isLoading = false.obs;
Rx<StudentListModel> studentListModel = StudentListModel().obs;
RxList<List<String>> depositDetailList = <List<String>>[].obs;

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
}
