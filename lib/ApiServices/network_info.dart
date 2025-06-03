import 'package:pg_managment/core/utils/navigation_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/progress_dialog_utils.dart';


// For checking internet connectivity
abstract class NetworkInfo {
  static Future<bool> checkNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      Get.closeAllSnackbars();
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      Get.closeAllSnackbars();
      return true;
    } else {
      if (connectivityResult.contains(ConnectivityResult.none)) {
        ProgressDialogUtils.hideProgressDialog() ;
        Get.closeAllSnackbars();

        AppFlushBars.appCommonFlushBar(
            context: NavigationService.navigatorKey.currentState!.context,
            message: 'NO INTERNET CONNECTION',
            success: false);
Future.delayed(Duration(seconds: 2),() {

        checkNetwork();
},);
        return false;
      } else {
        return true;
      }
    }
  }
}
