import 'package:get/get.dart';
import 'package:pg_managment/ApiServices/api_service.dart';
import 'package:pg_managment/core/utils/app_network_urls.dart';
import 'package:pg_managment/core/utils/pref_utils.dart';
import 'package:pg_managment/core/utils/string_constant.dart';
import '../model/notification_model.dart';

class NotificationScreenController extends GetxController {
  RxList<NotificationData> notifications = <NotificationData>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getNotifications();
  }

  Future<void> getNotifications() async {
    isLoading.value = true;
    try {
      // Try to get userId first, then fallback to isStudent
      var idValue = PrefUtils.getInt(StringConstants.userId);
      if (idValue == 0) {
        idValue = PrefUtils.getInt(StringConstants.isStudent);
      }

      String url = "${NetworkUrls.getNotificationsUrl}$idValue";
      print("Fetching notifications from: $url");

      final response = await ApiService().callGetApi(
        body: {},
        url: url,
        showLoader: false,
      );

      if (response != null) {
        print("Notification API Response Status: ${response.statusCode}");
        print("Notification API Response Body: ${response.body}");

        if (response.statusCode == 200 || response.statusCode == 201) {
          NotificationModel model = NotificationModel.fromJson(response.body);
          notifications.value = model.data ?? [];
          print("Parsed ${notifications.length} notifications");
        }
      } else {
        print("Notification API Response is null");
      }
    } catch (e) {
      print("Error fetching notifications: $e");
    } finally {
      isLoading.value = false;
    }
  }
  /// For all Delete
  // /delete-student-notification/{student_id?} ama student_id pass nai kare to badhi delete thai jase
  Future<void> deleteNotification(int notificationId) async {
    try {
      final response = await ApiService().callGetApi(
        body: {},
        url: "${NetworkUrls.deleteNotificationUrl}$notificationId",
        showLoader: true,
      );

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        notifications.removeWhere((element) => element.id == notificationId);
        getNotifications();
      }
    } catch (e) {
      print("Error deleting notification: $e");
    }
  }

  Future<void> clearAllNotifications() async {
    try {
      var studentId = PrefUtils.getInt(StringConstants.isStudent);
      final response = await ApiService().callGetApi(
        body: {},
        url: "${NetworkUrls.clearAllNotificationsUrl}$studentId",
        showLoader: true,
      );

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        notifications.clear();
      }
    } catch (e) {
      print("Error clearing notifications: $e");
    }
  }
}
