import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/size_utils.dart';
import 'package:pg_managment/routes/app_routes.dart';
import 'package:pg_managment/widgets/custom_app_text_form_field.dart';
import 'package:pg_managment/widgets/custom_elavated_button.dart';
import 'controller/login_screen_controller.dart';

class LoginScreen extends GetWidget<LoginScreenController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.primary,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "Login",
                      style: PMT.appStyle(
                          size: 30,
                          fontWeight: FontWeight.bold,
                          fontColor: ColorConstant.primaryWhite),
                    ),
                  ),
                  Divider(
                    color: ColorConstant.primaryWhite,
                    thickness: 3,
                  ),
                  vBox(20),
                  Text(
                    'Email',
                    style: PMT.appStyle(
                        size: 18,
                        fontWeight: FontWeight.w500,
                        fontColor: ColorConstant.primaryWhite),
                  ),
                  vBox(10),
                  CustomAppTextFormField(
                    controller: controller.emailController,
                    hintText: 'Enter Your Email',
                  ),
                  vBox(20),
                  Text(
                    'Password',
                    style: PMT.appStyle(
                        size: 18,
                        fontWeight: FontWeight.w500,
                        fontColor: ColorConstant.primaryWhite),
                  ),
                  vBox(10),
                  Obx(
                    () => CustomAppTextFormField(
                      isObscureText: !controller.isShow.value,
                      controller: controller.passwordController,
                      suffix: InkWell(
                          onTap: () {
                            controller.isShow.value = !controller.isShow.value;
                          },
                          child: Icon(controller.isShow.value
                              ? Icons.remove_red_eye
                              : CupertinoIcons.eye_slash_fill)),
                      hintText: 'Enter Your Password',
                    ),
                  ),
                  vBox(30),
                  AppElevatedButton(
                    buttonColor: ColorConstant.primaryBlack,
                    buttonName: 'Login',
                    onPressed: () {
                      controller.login(controller.emailController.text,
                          controller.passwordController.text);
                    },
                  ),
                  vBox(40),
                  Divider(
                    color: ColorConstant.primaryWhite,
                    thickness: 3,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
