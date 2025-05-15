import 'package:pg_managment/core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:another_flushbar/flushbar.dart';

class ProgressDialogUtils {
  static bool isProgressVisible = false;

  ///common method for showing progress dialog
  static void showProgressDialog({isCancellable = false}) async {
    if (!isProgressVisible) {
      Get.dialog(
        Center(
          child: CircularProgressIndicator.adaptive(
            strokeWidth: 4,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white,
            ),
          ),
        ),
        barrierDismissible: isCancellable,
      );
      isProgressVisible = true;
    }
  }

  ///common method for hiding progress dialog
  static void hideProgressDialog() {
    if (isProgressVisible) Get.back();
    isProgressVisible = false;
  }

  static void showSnackBar({headerText, bodyText}) {
    Get.closeAllSnackbars();
    Get.snackbar(headerText, bodyText,
        snackPosition: SnackPosition.BOTTOM,
        colorText: ColorConstant.primaryBlack,
        backgroundColor: ColorConstant.lightOrangeOutline,
        margin: EdgeInsets.only(bottom: 26, left: 16, right: 16));
  }
}

/// [AppFlushBars] contains common flush bars
class AppFlushBars {
  AppFlushBars._();

  static appCommonFlushBar({
    required BuildContext context,
    required String message,
    required bool success,
  }) {
    /// If you want success flushbar then give true to success
    return Flushbar(
      messageText: Text(
        message,
        style: TextStyle(
          color: ColorConstant.primaryWhite,
        ),
      ),
      icon: Image.asset(
        success
            ? 'assets/icons/done_round.png'
            : 'assets/icons/cancel_round.png',
        height: getWidth(25),
        width: getWidth(25),
      ),
      margin: EdgeInsets.all(
        getWidth(18),
      ),
      backgroundColor: success ? Colors.green : Colors.red,
      isDismissible: true,
      animationDuration: const Duration(milliseconds: 300),
      borderRadius: BorderRadius.circular(6),
      padding: EdgeInsets.symmetric(
        horizontal: getWidth(11),
        vertical: getHeight(9),
      ),
      duration: const Duration(seconds: 3),
    ).show(context);
  }
}
