import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pg_managment/core/utils/appRichText.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/size_utils.dart';
import 'package:pg_managment/presentation/expense_list_screen/expense_list_model.dart';
import 'package:pg_managment/routes/app_routes.dart';
import 'package:pg_managment/widgets/custom_app_text_form_field.dart';
import 'package:pg_managment/widgets/custom_elavated_button.dart';
import 'package:pg_managment/widgets/custom_image_view.dart';
import 'package:printing/printing.dart';
import 'controller/expense_list_screen_controller.dart';

class ExpenseListScreen extends GetWidget<ExpenseListScreenController> {
  const ExpenseListScreen({super.key});

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
          title: Text(
            'All Expense',
            style: PMT.appStyle(
                size: 20,
                // fontWeight: FontWeight.w600,
                fontColor: ColorConstant.primaryWhite),
          ),
        ),
        body: SafeArea(
          child: Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: CustomAppTextFormField(
                              controller: controller.month,
                              onTap: () {
                                controller.selectMonth(context);
                              },
                              readOnly: true,
                              variant: TextFormFieldVariant.OutlineGray200,
                              hintText: 'Select Month')),
                      hBox(10),
                      Expanded(
                          child: CustomAppTextFormField(
                              controller: controller.year,
                              readOnly: true,
                              variant: TextFormFieldVariant.OutlineGray200,
                              onTap: () {
                                controller.selectYear(context);
                              },
                              hintText: 'Select Year')),
                      hBox(10),
                      TextButton(
                          onPressed: () {
                            controller.getExpenseList(
                                month: controller.month.text,
                                year: controller.year.text);
                          },
                          child: Text('GO',
                              style: PMT.appStyle(
                                  size: 16,
                                  fontWeight: FontWeight.bold,
                                  fontColor: ColorConstant.primary)))
                    ],
                  ),
                  vBox(10),
                  controller.isLoading.value
                      ? Expanded(
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: ColorConstant.primary,
                            ),
                          ),
                        )
                      : controller.expenseListModel.value.data != null &&
                              controller.expenseListModel.value.data!.isEmpty
                          ? Expanded(
                              child: const Center(
                                child: Text('No data found'),
                              ),
                            )
                          : Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          width: getWidth(120),
                                          child: Text('Total Expanse :',
                                              style: PMT.appStyle(
                                                  size: 14,
                                                  fontColor:
                                                      Colors.grey.shade700))),
                                      Expanded(
                                        child: Text(
                                          '${controller.totalExpanse.value}' ??
                                              'N/A',
                                          style: PMT.appStyle(
                                              size: 14,
                                              fontColor: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: controller.expenseListModel
                                              .value.data?.length ??
                                          0,
                                      itemBuilder: (context, index) {
                                        Data? data = controller.expenseListModel
                                            .value.data?[index];

                                        return Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color:
                                                      ColorConstant.primary)),
                                          padding: const EdgeInsets.all(8),
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AppRichText(
                                                  title: 'Item : ',
                                                  value: data?.item ?? ''),
                                              vBox(5),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: AppRichText(
                                                          title: 'Amount : ',
                                                          value:
                                                              '${data?.amount ?? ' '}')),
                                                  Expanded(
                                                      child: AppRichText(
                                                          title: 'Date : ',
                                                          value:
                                                              '${DateFormat("yyyy-MM-dd").format(data?.date ?? DateTime.now())}')),
                                                ],
                                              ),
                                              vBox(5),
                                              AppRichText(
                                                  title: 'Remark : ',
                                                  value: data?.remark ?? ' '),
                                              vBox(5),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                      child: IconButton(
                                                          style: IconButton.styleFrom(
                                                              backgroundColor:
                                                                  ColorConstant
                                                                      .primaryBlack
                                                                      .withOpacity(
                                                                          0.3)),
                                                          onPressed: () {
                                                            Get.toNamed(
                                                                AppRoutes
                                                                    .addExpenseScreenRoute,
                                                                arguments: {
                                                                  "data": data,
                                                                  "isAddEdit": 2
                                                                });
                                                          },
                                                          icon: CustomImageView(
                                                            height: 20,
                                                            width: 20,
                                                            imagePath:  'assets/images/list.png' ,
                                                            color: ColorConstant
                                                                .primaryBlack,
                                                          ))),
                                                  hBox(10),
                                                  Expanded(
                                                      child: IconButton(
                                                          style: IconButton.styleFrom(
                                                              backgroundColor:
                                                                  ColorConstant
                                                                      .primary
                                                                      .withOpacity(
                                                                          0.3)),
                                                          onPressed: () {
                                                            Get.toNamed(
                                                                AppRoutes
                                                                    .addExpenseScreenRoute,
                                                                arguments: {
                                                                  "data": data,
                                                                  "isAddEdit": 1
                                                                })?.then(
                                                                (value) {
                                                              controller.getExpenseList(
                                                                  month:
                                                                      '${DateTime.now().month}',
                                                                  year:
                                                                      '${DateTime.now().year}');
                                                            });
                                                          },
                                                          icon:   CustomImageView(
                                                            height: 20,
                                                            width: 20,
                                                            imagePath:  'assets/images/pencil.png' ,
                                                            color: ColorConstant
                                                                .primary,
                                                          ))),
                                                  hBox(10),
                                                  Expanded(
                                                      child: IconButton(
                                                          style: IconButton.styleFrom(
                                                              backgroundColor:
                                                                  ColorConstant
                                                                      .red
                                                                      .withOpacity(
                                                                          0.3)),
                                                          onPressed: () {
                                                            controller
                                                                .showDeleteConfirmationDialog(
                                                              context,
                                                              () {
                                                                controller
                                                                    .deleteExpense(
                                                                        id: data
                                                                            ?.id
                                                                            .toString());
                                                              },
                                                            );
                                                          },
                                                          icon: CustomImageView(
                                                            height: 20,
                                                            width: 20,
                                                            imagePath:  'assets/images/delete.png' ,
                                                            color: ColorConstant
                                                                .red,
                                                          )))
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                ],
              ),
            ),
          ),
        ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16,right: 16,bottom: 10),
        child: AppElevatedButton(
          buttonName: 'Download PDF',
          onPressed: () async {
            final pdfData = await controller.generatePdf();
            await Printing.sharePdf(
              bytes: pdfData,

              filename: 'Expanse Repost ${DateTime.now()}.pdf',
            );
          },
        ),
      ),
    );
  }
}
