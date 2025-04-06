
import 'package:flutter/material.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/size_utils.dart';

abstract class PMT {
  /// Default font family
  static const String defaultFontOfApp = 'Inter';
  static const String _defaultFontFamily = defaultFontOfApp;
  static const FontWeight _defaultFontWeight = FontWeight.w400;
  static const defaultFontColor = ColorConstant.textDarkBrown;

  //static var defaultFontColor = LmgColors().fontBlack;

  static TextStyle style(int size, {Color? fontColor, String? fontFamily, FontWeight? fontWeight}) {
    switch (size) {
      case 10:
        return TextStyle(
            fontFamily: fontFamily ?? _defaultFontFamily,
            fontSize: getFontSize(7),
            fontWeight: fontWeight??_defaultFontWeight,
            color: fontColor ?? defaultFontColor);

      case 12:
        return TextStyle(
            fontFamily: fontFamily ?? _defaultFontFamily,
            fontSize: getFontSize(9), //7.5.sp
            fontWeight: fontWeight??_defaultFontWeight,
            color: fontColor ?? defaultFontColor);

      case 36:
        return TextStyle(
            fontFamily: fontFamily ?? _defaultFontFamily,
            fontSize: getFontSize(36), //8.sp,
            fontWeight: fontWeight??_defaultFontWeight,
            color: fontColor ?? defaultFontColor);

      default:
        return TextStyle(
            fontFamily: fontFamily ?? _defaultFontFamily,
            fontSize: getFontSize(10.5), //12,
            fontWeight: fontWeight??_defaultFontWeight,
            color: fontColor ?? defaultFontColor);
    }
  }

  static TextStyle appStyle( {double? size,Color? fontColor, String? fontFamily, FontWeight? fontWeight}){
    return TextStyle(
        fontFamily: fontFamily ?? _defaultFontFamily,
        fontSize: getFontSize(size??14), //12,
        fontWeight: fontWeight??_defaultFontWeight,
        color: fontColor ?? defaultFontColor);
  }
}