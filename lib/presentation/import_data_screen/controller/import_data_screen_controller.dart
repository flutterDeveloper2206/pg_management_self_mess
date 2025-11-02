import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pg_managment/ApiServices/api_service.dart';
import 'package:pg_managment/core/utils/app_network_urls.dart';
import 'package:pg_managment/core/utils/navigation_service.dart';
import 'package:pg_managment/core/utils/progress_dialog_utils.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

class ImportDataScreenController extends GetxController {
  var jsonData = <Map<String, dynamic>>[].obs;
  var fileName = ''.obs;
  var isLoading = false.obs;

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'xlsx', 'xls'],
      );

      if (result != null) {
        fileName.value = result.files.single.name;
        isLoading.value = true;

        final filePath = result.files.single.path!;
        if (filePath.endsWith('.csv')) {
          await _parseCsv(filePath);
        } else {
          await _parseExcel(filePath);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to read file: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _parseCsv(String path) async {
    final file = File(path);
    final lines = await file.readAsLines();
    if (lines.isEmpty) return;

    final headers = lines.first.split(',').map((e) => e.trim()).toList();
    final data = lines.skip(1).map((line) {
      final values = line.split(',').map((e) => e.trim()).toList();
      return Map<String, dynamic>.fromIterables(headers, values);
    }).toList();

    jsonData.assignAll(data);
  }

  Future<void> _parseExcel(String path) async {
    final bytes = File(path).readAsBytesSync();
    final decoder = SpreadsheetDecoder.decodeBytes(bytes, update: false);
    final sheet = decoder.tables.values.first;
    if (sheet.rows.isEmpty) return;

    final headers =
    sheet.rows.first.map((e) => e?.toString().trim() ?? '').toList();

    final data = sheet.rows.skip(1).map((row) {
      final values = row.map((e) => e?.toString().trim() ?? '').toList();
      return Map<String, dynamic>.fromIterables(headers, values);
    }).toList();
    jsonData.assignAll(data);
  }
  Future<void> sendDataToServer() async {
    isLoading.value = true;
    await ApiService().callPostApi(
        body: {
          "student_details" :jsonData
        },
        headerWithToken: true,
        showLoader: true,
        url: NetworkUrls.sendBulkData).then((value) async {
      isLoading.value = false;
      if (value != null && value.statusCode == 200) {
        isLoading.value = false;

        Get.back();
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          AppFlushBars.appCommonFlushBar(
              context: NavigationService.navigatorKey.currentContext!,
              message: "Data Send successfully",
              success: true);
        });
      }
    });
  }
}
