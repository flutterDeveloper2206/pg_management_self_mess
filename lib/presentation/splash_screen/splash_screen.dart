import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/widgets/custom_image_view.dart';
import 'controller/splash_screen_controller.dart';

class SplashScreen extends GetWidget<SplashScreenController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.primary,
        body: Center(
          child: 
          Text('SELF-MESS',style: PMT.appStyle(size: 40,fontColor: ColorConstant.primaryWhite,fontWeight: FontWeight.bold),),
        ));
  }
}
