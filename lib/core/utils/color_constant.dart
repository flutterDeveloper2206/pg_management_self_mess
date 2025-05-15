import 'package:flutter/material.dart';

class ColorConstant {
  static const Color primaryWhite = Color(0xFFffffff);
  static const Color green = Color.fromARGB(255, 0, 153, 54);
  static const Color primary = Color(0xFF009999);
  static const Color primaryBlack = Color(0xFF000000);
  static const Color red = Color(0xFFEE0606);
  static const Color textGreyColor = Color(0xFF8D919F);
  static const Color textDarkBrown = Color(0xFF17120D);
  static const Color greyBackGroundColor = Color(0xFFECECEE);
  static const Color lightGrey = Color(0xFFF8FAFC);
  static const Color dividerGreyColor = Color(0xFFF8D919F);
  static const Color borderGreyColor = Color(0xFFF6A6E77);
  static const Color textDarkGreyColor = Color(0xFFF8D919F);
  static const Color bgGrey = Color(0xFFF0F5FA);
  static const Color icGrayColor = Color(0xFF8D919F);
  static const Color transparent = Colors.transparent;
  static const Color greyBack = Color(0xFFF8FAFC);
  static const Color lightOrange = Color(0xFFFFEDDD);
  static const Color lightOrangeOutline = Color(0xFFFFDEC6);
  static const Color shadowColor = Color(0xFF62697B);
  static const Color ratingStartOutlineColor = Color(0x1AFFFFFF);
  static const Color bottomSheetDragColor = Color(0x6679747E);
  static const Color dropDownIconColor = Color(0xFF6A7286);

  // static Color black900Af = fromHex('#af000000');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
