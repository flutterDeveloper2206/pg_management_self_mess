abstract class NetworkUrls {
  /// base url
  static String baseUrl = 'https://goselfmess.in/api/';

  /// login url
  static String loginUrl = '${baseUrl}login';

  /// student list url
  static String studentListUrl = '${baseUrl}admin/students';

  /// student delete url
  static String studentDeleteUrl = '${baseUrl}admin/students/';

  /// student update url
  static String studentUpdateUrl = '${baseUrl}admin/students/';

  /// student add url
  static String studentAddUrl = '${baseUrl}admin/students';

  /// expense list url
  static String expenseListUrl = '${baseUrl}admin/expenses?';

  /// expense add url
  static String expenseAddUrl = '${baseUrl}admin/expenses';

  /// expense update url
  static String expenseUpdateUrl = '${baseUrl}admin/expenses/';

  /// expense delete url
  static String expenseDeleteUrl = '${baseUrl}admin/expenses/';

  /// day details list url
  static String dayDetailsListUrl = '${baseUrl}admin/student-details?';

  /// day details add url
  static String dayDetailsAddUrl = '${baseUrl}admin/student-details';

  /// day details update url
  static String dayDetailsUpdateUrl = '${baseUrl}admin/student-details/';

  /// day details delete url
  static String dayDetailsDeleteUrl = '${baseUrl}admin/student-details/';

  /// calculate rate url
  static String calculateRateUrl = '${baseUrl}admin/generate-bill';

  /// generate bill url
  static String updateAllBillUrl = '${baseUrl}admin/update-remain-amount';
  static String generateBillUrl = '${baseUrl}admin/update-generated-bill';
  static String sendBulkData = '${baseUrl}admin/bulk-store';

  /// student_profile url
  static String studentProfile = '${baseUrl}admin/students/';

  /// get config url
  static String getConfigUrl = '${baseUrl}admin/configs';

  /// monthly transaction url
  static String monthlyTransactionUrl =
      '${baseUrl}admin/get-monthly-transaction';

  /// update fcm token url
  static String updateFcmTokenUrl = '${baseUrl}admin/update-fcm-token';

  /// day meals url
  static String dayMealsUrl = '${baseUrl}admin/day-meals';

  /// send notification url
  static String sendNotificationUrl = '${baseUrl}admin/send-notification';

  /// notifications list url
  static String getNotificationsUrl = '${baseUrl}admin/notifications/';

  /// delete notification url
  static String deleteNotificationUrl = '${baseUrl}admin/delete-notification/';

  /// clear all notifications url
  static String clearAllNotificationsUrl =
      '${baseUrl}admin/delete-student-notification/';

  /// chart stats url
  static String chartStatsUrl = '${baseUrl}admin/chart-stats';
}
