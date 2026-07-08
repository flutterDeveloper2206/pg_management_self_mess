import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pg_managment/core/utils/string_constant.dart';
import 'package:pg_managment/widgets/update_dialog.dart';
import 'package:pg_managment/ApiServices/api_service.dart';
import 'package:pg_managment/core/utils/app_network_urls.dart';

class VersionCheckHelper {
  static const String currentVersion = '1.0.5';

  static bool isUpdateRequired(String current, String minVersion) {
    try {
      List<int> currentParts = current.split('.').map(int.parse).toList();
      List<int> minParts = minVersion.split('.').map(int.parse).toList();

      while (currentParts.length < 3) currentParts.add(0);
      while (minParts.length < 3) minParts.add(0);

      for (int i = 0; i < 3; i++) {
        if (currentParts[i] < minParts[i]) {
          return true;
        } else if (currentParts[i] > minParts[i]) {
          return false;
        }
      }
    } catch (e) {
      debugPrint('Error parsing versions: $e');
    }
    return false;
  }

  static Future<bool> checkAndShowUpdateDialog() async {
    if (kIsWeb) return false;

    String minVersion = StringConstants.minSupportedAppVersion;
    String updateUrl = StringConstants.appUpdateUrl;

    try {
      final response = await ApiService().callGetApi(
        body: {},
        headerWithToken: false,
        showLoader: false,
        url: NetworkUrls.getConfigUrl,
      );

      if (response != null &&
          response.statusCode == 200 &&
          response.body != null) {
        final dataList = response.body['data'];
        if (dataList is List) {
          for (var item in dataList) {
            if (item is Map) {
              if (item['config_key'] == 'min_supported_version') {
                minVersion = item['config_value']?.toString() ?? minVersion;
              }
              if (item['config_key'] == 'app_update_url') {
                updateUrl = item['config_value']?.toString() ?? updateUrl;
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching remote version config: $e');
    }

    if (isUpdateRequired(currentVersion, minVersion)) {
      Get.dialog(
        UpdateDialog(updateUrl: updateUrl, version: minVersion),
        barrierDismissible: false,
      );
      return true;
    }

    return false;
  }
}
