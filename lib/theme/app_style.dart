import 'package:flutter/material.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/size_utils.dart';

class AppStyle {



  static TextStyle txtGilroy = TextStyle(
    color: ColorConstant.textGreyColor,
    fontSize: getFontSize(
      14,
    ),
    fontFamily: 'Gilroy-Bold',
    fontWeight: FontWeight.w400  ,
  );
    static TextStyle txtGilroyMedium = TextStyle(
    color: ColorConstant.textDarkBrown,
    fontSize: getFontSize(
      12,
    ),
    fontFamily: 'Gilroy-Medium',
    fontWeight: FontWeight.w400,
  );
  static TextStyle  txtGilroyBold = TextStyle(
    color: ColorConstant.primaryWhite,
    fontSize: getFontSize(
      12,
    ),
    fontFamily: 'Gilroy-Bold',
    fontWeight: FontWeight.w400,
  );

  static TextStyle txtGilroySemiBold = TextStyle(
    color: ColorConstant.textDarkBrown,
    fontSize: getFontSize(
      12,
    ),
    fontFamily: 'Gilroy-SemiBold',
    fontWeight: FontWeight.w400,
  );
  static TextStyle txtGilroyExtraBold = TextStyle(
    color: ColorConstant.primaryWhite,
    fontSize: getFontSize(
      12,
    ),
    fontFamily: 'Gilroy-ExtraBold',
    fontWeight: FontWeight.w400,
  );

}
