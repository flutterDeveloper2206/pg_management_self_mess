import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/size_utils.dart';
import 'package:pg_managment/widgets/custom_app_text_form_field.dart';
import 'package:pg_managment/widgets/custom_image_view.dart';
import '../../widgets/custom_elavated_button.dart';
import 'controller/import_data_screen_controller.dart';

class ImportDataScreen extends GetWidget<ImportDataScreenController> {
  const ImportDataScreen({super.key});

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
          icon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomImageView(
                height: 40,
                width: 40,
                imagePath: 'assets/images/left-arrow.png',
                color: ColorConstant.primaryWhite),
          ),
        ),
        title: Text(
          'Import Data',
          style: PMT.appStyle(
              size: 20,
              // fontWeight: FontWeight.w600,
              fontColor: ColorConstant.primaryWhite),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: controller.pickFile,
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Pick CSV or Excel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstant.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      controller.fileName.value.isEmpty
                          ? 'No file selected'
                          : '📄 ${controller.fileName.value}',
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: controller.jsonData.isEmpty
                  ? const Center(
                      child: Text(
                        'No data loaded yet.\nPick a file to display data.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : _buildDataTable(),
            ),
            SizedBox(
              height: 20,
            )
          ],
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 5),
        child: AppElevatedButton(
          buttonName: 'Send Data To Server',
          onPressed: () async {
            _showConfirmDialog(context);
          },
        ),
      ),
    );
  }

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Send Data To Server',
            style: PMT.appStyle(
              size: 18,
              fontWeight: FontWeight.w600,
              fontColor: Colors.black87,
            ),
          ),
          content: Text(
            'Are you sure you want to send?',
            style: PMT.appStyle(
              size: 14,
              fontWeight: FontWeight.w400,
              fontColor: Colors.black54,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: PMT.appStyle(
                  size: 14,
                  fontWeight: FontWeight.w500,
                  fontColor: Colors.grey[600]!,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.sendDataToServer();
                // PrefUtils.clearPreferencesData();
                // Get.offAllNamed(AppRoutes.loginScreenRoute);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                'Send',
                style: PMT.appStyle(
                  size: 14,
                  fontWeight: FontWeight.w500,
                  fontColor: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDataTable() {
    final data = controller.jsonData;
    final headers = data.first.keys.toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          headingRowColor:
              MaterialStateProperty.all(ColorConstant.primary.withOpacity(0.2)),
          border: TableBorder.all(color: Colors.grey.shade300),
          columns: headers
              .map((key) => DataColumn(
                    label: Text(
                      key,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ))
              .toList(),
          rows: data
              .map((row) => DataRow(
                    cells: headers
                        .map((key) => DataCell(Text(
                              row[key]?.toString() ?? '',
                              style: const TextStyle(fontSize: 12),
                            )))
                        .toList(),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
