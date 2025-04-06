import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:pg_managment/core/utils/appRichText.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/size_utils.dart';
import 'controller/student_list_screen_controller.dart';

class StudentListScreen extends GetWidget<StudentListScreenController> {
  const StudentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.primaryWhite,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ColorConstant.primary,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: ColorConstant.primaryWhite,
              )),
          title: Text(
            'All Student',
            style: PMT.appStyle(
                size: 20,
                // fontWeight: FontWeight.w600,
                fontColor: ColorConstant.primaryWhite),
          ),
        ),
        body: SafeArea(child:
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
          child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ColorConstant.primary)
                ),
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 10),
                child:  Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppRichText(title: 'Name : ', value: 'Kishan'),
                    vBox(5),
                    Row(
                      children: [
                        Expanded(child: AppRichText(title: 'Roll no. : ', value: '4562')),
                        Expanded(child: AppRichText(title: 'Year : ', value: '2022')),
                      ],
                    ),
                    vBox(5),

                    AppRichText(title: 'Deposit : ', value: '1000.00'), vBox(5),

                    AppRichText(title: 'Mobile Nu. : ', value: '9023256219'),


                  ],
                ),
              );
            },
          ),
        )));
  }
}
