import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pg_managment/core/utils/appRichText.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/size_utils.dart';
import 'package:pg_managment/presentation/expense_list_screen/expense_list_model.dart';
import 'package:pg_managment/routes/app_routes.dart';
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
              icon: const Icon(
                Icons.arrow_back_ios,
                color: ColorConstant.primaryWhite,
              )),
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
            () => controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                      color: ColorConstant.primary,
                    ),
                  )
                : controller.expenseListModel.value.data != null &&
                        controller.expenseListModel.value.data!.isEmpty
                    ? const Center(
                        child: Text('No data found'),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: getWidth(120), child: Text('Total Expanse :', style: PMT.appStyle(size: 14, fontColor: Colors.grey.shade700))),
                                Expanded(
                                  child: Text(
                                    '${controller.totalExpanse.value}' ?? 'N/A',
                                    style: PMT.appStyle(size: 14, fontColor: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),                            SizedBox(height: 20,),
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    controller.expenseListModel.value.data?.length ??
                                        0,
                                itemBuilder: (context, index) {
                                  Data? data =
                                      controller.expenseListModel.value.data?[index];

                                  return Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border:
                                            Border.all(color: ColorConstant.primary)),
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                                    value: '${data?.amount ?? ' '}')),
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                                child: IconButton(
                                                    style: IconButton.styleFrom(
                                                        backgroundColor: ColorConstant
                                                            .primaryBlack
                                                            .withOpacity(0.3)),
                                                    onPressed: () {
                                                      Get.toNamed(
                                                          AppRoutes
                                                              .addExpenseScreenRoute,
                                                          arguments: {
                                                            "data": data,
                                                            "isAddEdit": 2
                                                          });
                                                    },
                                                    icon: const Icon(
                                                      Icons.view_list,
                                                      color:
                                                          ColorConstant.primaryBlack,
                                                    ))),
                                            hBox(10),
                                            Expanded(
                                                child: IconButton(
                                                    style: IconButton.styleFrom(
                                                        backgroundColor: ColorConstant
                                                            .primary
                                                            .withOpacity(0.3)),
                                                    onPressed: () {
                                                      Get.toNamed(
                                                          AppRoutes
                                                              .addExpenseScreenRoute,
                                                          arguments: {
                                                            "data": data,
                                                            "isAddEdit": 1
                                                          })?.then((value) {
                                                        controller.getExpenseList(
                                                            month:
                                                                '${DateTime.now().month}',
                                                            year:
                                                                '${DateTime.now().year}');
                                                      });
                                                    },
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      color: ColorConstant.primary,
                                                    ))),
                                            hBox(10),
                                            Expanded(
                                                child: IconButton(
                                                    style: IconButton.styleFrom(
                                                        backgroundColor: ColorConstant
                                                            .red
                                                            .withOpacity(0.3)),
                                                    onPressed: () {
                                                      controller.deleteExpense(
                                                          id: data?.id.toString());
                                                    },
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: ColorConstant.red,
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
          ),
        ));
  }
}
