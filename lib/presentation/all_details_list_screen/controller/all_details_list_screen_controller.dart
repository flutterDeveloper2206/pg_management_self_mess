import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pg_managment/core/utils/app_network_urls.dart';
import 'package:pg_managment/core/utils/navigation_service.dart';
import 'package:pg_managment/core/utils/progress_dialog_utils.dart';
import 'package:pg_managment/presentation/all_details_list_screen/all_details_list_model.dart';

import '../../../ApiServices/api_service.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
class AllDetailsListScreenController extends GetxController {
  RxBool isLoading = false.obs;
  RxDouble totalCollection = 0.0.obs;
  RxDouble totalRemaining = 0.0.obs;
  Rx<StudentAllDetailsModel> allStudentListModel = StudentAllDetailsModel().obs;
  TextEditingController month = TextEditingController();
  TextEditingController year = TextEditingController();
  RxList<List<String>> studentMonthlyStudentList = <List<String>>[].obs;
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
          element.id!.toString().toLowerCase().contains(search)

      )
          .toList() ??
          [];
    }
    update();
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
        if(allStudentListModel.value.data!=null &&allStudentListModel.value.data!.isNotEmpty) {
          totalCollection.value=0.0;
          totalRemaining.value=0.0;
          studentMonthlyStudentList.value =
              generateStudentTableList(allStudentListModel.value) ?? [];
          studentListSearch.value = allStudentListModel.value.data ?? [];

          allStudentListModel.value.data?.forEach((element) {
            totalCollection.value = totalCollection.value+(element.paidAmount??0).toDouble()??0.0;
            totalRemaining.value = totalRemaining.value+(element.remainAmount??0).toDouble()??0.0;

          },);
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
          pw.Text('Student Monthly Report',
              style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 16),
          pw.Text('Date: ${DateTime.now().toLocal()}'),
          pw.SizedBox(height: 16),
          pw.Text('This is a  PDF report with All Student Monthly data.'),
          pw.SizedBox(height: 16),

          pw.Text('Total Collection : ${totalCollection.value}'),
          pw.SizedBox(height: 16),
          pw.Text('Total Remaining : ${totalRemaining.value}'),
          pw.SizedBox(height: 16),

          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: ['Student ID', 'Student Name', 'Total Day','Total Eat Day','Cut Day',
              'Simple Guest','Feast Guest','Rate','Penalty Amount','Paid Amount','Total Amount'],            data: studentMonthlyStudentList,
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
