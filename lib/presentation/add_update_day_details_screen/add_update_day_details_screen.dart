import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pg_managment/core/utils/appRichText.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/size_utils.dart';
import 'package:pg_managment/widgets/custom_app_text_form_field.dart';
import 'package:pg_managment/widgets/custom_elavated_button.dart';
import 'package:pg_managment/widgets/custom_image_view.dart';
import 'controller/add_update_day_details_screen_controller.dart';

class AddUpdateDayDetailsScreen
    extends GetWidget<AddUpdateDayDetailsScreenController> {
  const AddUpdateDayDetailsScreen({super.key});

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
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomImageView(
                    height: 40,
                    width: 40,
                    imagePath:  'assets/images/left-arrow.png' ,color: ColorConstant.primaryWhite),
              ),),
          title: Obx(
            () => Text(
              controller.isAdd.value == 2
                  ? 'View ${controller.studentName.value} Details'
                  : controller.isAdd.value == 1
                      ? 'Edit ${controller.studentName.value} Detail'
                      : 'Add ${controller.studentName.value} Details',
              style: PMT.appStyle(
                  size: 20,
                  // fontWeight: FontWeight.w600,
                  fontColor: ColorConstant.primaryWhite),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  vBox(20),
                  Row(
                    children: [
                      Expanded(
                        child: titleWidget(
                            readOnly: controller.readOnly.value,
                            title: 'Total Meal Day',
                            hintText: 'Total Meal Day',
                            textInputType: TextInputType.number,
                            controller: controller.totalDayController),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: titleWidget(
                            readOnly: controller.readOnly.value,
                            textInputType: TextInputType.number,
                            title: 'Meal Day Attended',
                            hintText: 'Meal Day Attended',
                            onChanged: (p0) {
                              controller.changeEatDay(p0);
                            },
                            controller: controller.totalEatDayController),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: titleWidget(
                              readOnly: controller.readOnly.value,
                              textInputType: TextInputType.number,
                              onChanged: (p0) {
                                controller.changeCutDay(p0);

                              },
                              title: 'Cut Day',
                                hintText: 'Cut Day',
                              controller: controller.cutDayController)),
                      hBox(20),
                      Expanded(
                          child: titleWidget(
                              readOnly: true,
                              textInputType: TextInputType.number,
                              title: 'Date',
                              onTap: () {
                                controller.selectDate(context);
                              },
                              hintText: 'Date',
                              controller: controller.dateController)),
                    ],
                  ),
                  titleWidget(
                      readOnly: true,
                      textInputType: TextInputType.number,
                      title: 'Par Day Rate (₹)',
                      hintText: 'Par Day Rate',
                      controller: TextEditingController(
                          text:
                          '${controller.dataGet.value.rate ?? ' '}')),
                  titleWidget(
                      readOnly: true,
                      textInputType: TextInputType.number,
                      title: 'Current Bill',
                      hintText: 'Current Bill',
                      controller: TextEditingController(
                          text:
                          '${controller.dataGet.value.amount ?? ' '}')),

                  Row(
                    children: [
                      Expanded(
                          child: titleWidget(
                              readOnly: controller.readOnly.value,
                              textInputType: TextInputType.number,
                              title: 'Simple Guest',
                              hintText: 'Simple Guest',
                              onChanged: (p0) {

                                controller.calculateSimpleGuestAmount(p0);
                                controller.changeFeastAndSimple(p0,true);
                              },
                              controller: controller.simpleGuestController)),
                      hBox(20),
                      Expanded(
                          child: titleWidget(
                              readOnly: controller.readOnly.value,
                              textInputType: TextInputType.number,
                              onChanged: (p0) {
                                controller.calculateFeastGuestAmount(p0);
                                controller.changeFeastAndSimple(p0,false);

                              },
                              title: 'Feast Guest',
                              hintText: 'Feast Guest',
                              controller: controller.feastGuestController)),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: titleWidget(
                              readOnly: controller.readOnly.value,
                              textInputType: TextInputType.number,
                              onChanged: (p0) {
                                controller.changeTotalAmountSimpleGuest(p0);
                              },
                              title: 'Simple Guest Charge',
                              hintText: 'Simple Guest Charge',
                              controller:
                                  controller.simpleGuestAmountController)),
                      hBox(20),
                      Expanded(
                          child: titleWidget(
                            onChanged: (p0) {
                              controller.changeTotalAmountFeastGuest(p0);
                            },
                              readOnly: controller.readOnly.value,
                              textInputType: TextInputType.number,
                              title: 'Feast Guest Charge',
                              hintText: 'Feast Guest Charge',
                              controller:
                                  controller.feastGuestAmountController)),
                    ],
                  ),  Row(
                    children: [
                      Expanded(
                          child: titleWidget(
                              readOnly: controller.readOnly.value,
                              textInputType: TextInputType.number,
                              title: 'Due Amount / Unpaid',
                              hintText: 'Due Amount / Unpaid',
                              controller: TextEditingController(
                                  text:
                                  '${controller.dataGet.value.dueAmount ?? ' '}'))),
                      hBox(20),

                      Expanded(
                          child: titleWidget(
                              readOnly: controller.readOnly.value,
                              textInputType: TextInputType.number,
                              title: 'Penalty Amount ',
                              onChanged: (p0) {
                                controller.changeTotalAmountPenalty(p0);
                              },
                              hintText: 'Penalty Amount ',
                              controller: controller.penaltyAmountController)),

                    ],
                  ),
                titleWidget(
                    readOnly: controller.readOnly.value,
                    textInputType: TextInputType.number,
                    title: 'Final Bill',
                    hintText: 'Final Bill',
onChanged: (p0) {
  controller.setRemainingAmount();

},
                    controller: controller.totalAmountController
                    // controller: TextEditingController(
                    //     text:
                    //     '${controller.dataGet.value.totalAmount ?? ' '}')
                      ),

            Row(
                    children: [

                      Expanded(
                          child: titleWidget(
                              readOnly: controller.readOnly.value,
                              textInputType: TextInputType.number,
                              title: 'Paid Amount ',
                              hintText: 'Paid Amount ',
                              onChanged: (p0) {
                                controller.setRemainAmountCalculate();
                              },
                              controller: controller.paidAmountController)),
                      hBox(20),

                      Expanded(
                          child: titleWidget(
                              readOnly: true,
                              textInputType: TextInputType.number,
                              title: 'Remain Amount ',
                              hintText: 'Remain Amount ',
                              controller:  controller.remainController
                              // controller: TextEditingController(
                              //     text:
                              //     '${controller.dataGet.value.remainAmount ?? ' '}')
                          )),

                      // Expanded(
                      //   child: titleWidget(
                      //       readOnly: true,
                      //       textInputType: TextInputType.number,
                      //       title: 'Current Amount',
                      //       hintText: 'Current Amount',
                      //       controller: TextEditingController(
                      //           text:
                      //           '${controller.dataGet.value.totalAmount ?? ' '}')),
                      // ),

                    ],
                  ),


                  // Obx(() => controller.isAdd.value == 2
                  //     ?
                  // Column(
                  //         children: [
                  //           Row(
                  //             children: [
                  //
                  //               // Expanded(
                  //               //     child: titleWidget(
                  //               //         readOnly: controller.readOnly.value,
                  //               //         textInputType: TextInputType.number,
                  //               //         title: 'Dua Amount',
                  //               //         hintText: 'Dua Amount',
                  //               //         controller: TextEditingController(
                  //               //             text:
                  //               //                 '${controller.dataGet.value.dueAmount ?? ' '}'))),
                  //                        Expanded(
                  //                   child: titleWidget(
                  //                       readOnly: true,
                  //                       textInputType: TextInputType.number,
                  //                       title: 'Remain Amount ',
                  //                       hintText: 'Remain Amount ',
                  //                       controller: TextEditingController(
                  //                           text:
                  //                               '${controller.dataGet.value.remainAmount ?? ' '}'))),
                  //
                  //               hBox(20),
                  //               Expanded(
                  //                 child: titleWidget(
                  //                     readOnly: true,
                  //                     textInputType: TextInputType.number,
                  //                     title: 'Total Amount',
                  //                     hintText: 'Total Amount',
                  //                     controller: TextEditingController(
                  //                         text:
                  //                         '${controller.dataGet.value.totalAmount ?? ' '}')),
                  //               ),
                  //
                  //             ],
                  //           ),
                  //           ],
                  //       )
                  //     : SizedBox.shrink()),
                  titleWidget(
                      readOnly: controller.readOnly.value,
                      title: 'Remark',
                      hintText: 'Enter Remark ',
                      maxLine: 3,
                      controller: controller.remarkController),
                  controller.isAdd.value != 2
                      ? AppElevatedButton(
                          buttonName:
                              controller.isAdd.value == 1 ? 'Update ' : 'Save',
                          onPressed: () {
                            controller.updateAddStudentDetails(
                                id: controller.dataGet.value.id.toString());
                          },
                        )
                      : SizedBox.shrink()
                ],
              ),
            ),
          ),
        ));
  }

  Widget titleWidget(
      {required String title,
      required String hintText,
      required TextEditingController controller,
      TextInputType? textInputType,
        Function(String)? onChanged,
      bool? readOnly,
      int? maxLine,
      Function()? onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: PMT.appStyle(
              size: 14,
              fontWeight: FontWeight.w600,
              fontColor: ColorConstant.primary),
        ),
        vBox(5),
        CustomAppTextFormField(
          readOnly: readOnly,
          maxLines: maxLine,
          onTap: onTap,
          textInputType: textInputType,
          controller: controller,
          onChanged: onChanged,
          variant: TextFormFieldVariant.OutlineGray200,
          hintText: hintText,
        ),
        vBox(20),
      ],
    );
  }
}
