import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/size_utils.dart';
import 'package:pg_managment/widgets/custom_app_text_form_field.dart';
import 'package:pg_managment/widgets/custom_elavated_button.dart';
import 'package:pg_managment/widgets/custom_image_view.dart';
import 'controller/send_notification_screen_controller.dart';

class SendNotificationScreen
    extends GetWidget<SendNotificationScreenController> {
  SendNotificationScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.primaryWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorConstant.primary,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomImageView(
              height: 40,
              width: 40,
              imagePath: 'assets/images/left-arrow.png',
              color: ColorConstant.primaryWhite,
            ),
          ),
        ),
        title: Text(
          'Send Notification',
          style: PMT.appStyle(
            size: 20,
            fontColor: ColorConstant.primaryWhite,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  vBox(20),
                  _buildLabel('Notification Title'),
                  vBox(8),
                  CustomAppTextFormField(
                    controller: controller.titleController,
                    hintText: 'Enter title (e.g., Dinner Time!)',
                    variant: TextFormFieldVariant.OutlineGray200,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Title is required';
                      }
                      return null;
                    },
                  ),
                  vBox(24),
                  _buildLabel('Notification Type'),
                  vBox(8),
                  Obx(() => Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: controller.selectedType.value,
                            isExpanded: true,
                            items: [
                              'announcement',
                              'alert',
                              'reminder',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                controller.selectedType.value = value;
                              }
                            },
                          ),
                        ),
                      )),
                  vBox(24),
                  // _buildLabel('Payload Date'),
                  // vBox(8),
                  // CustomAppTextFormField(
                  //   controller: controller.dateController,
                  //   hintText: 'Select Date',
                  //   readOnly: true,
                  //   onTap: () => controller.selectDate(context),
                  //   variant: TextFormFieldVariant.OutlineGray200,
                  // ),
                  // vBox(24),
                  _buildLabel('Notification Message'),
                  vBox(8),
                  CustomAppTextFormField(
                    controller: controller.bodyController,
                    hintText: 'Enter message body',
                    maxLines: 5,
                    variant: TextFormFieldVariant.OutlineGray200,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Message body is required';
                      }
                      return null;
                    },
                  ),
                  vBox(40),
                  AppElevatedButton(
                    buttonName: 'Send To All Students',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        controller.sendNotification();
                      }
                    },
                  ),
                  vBox(20),
                  _buildNote(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: PMT.appStyle(
        size: 14,
        fontWeight: FontWeight.w600,
        fontColor: ColorConstant.primary,
      ),
    );
  }

  Widget _buildNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.blue, size: 20),
          hBox(12),
          Expanded(
            child: Text(
              'This will send a push notification to all students currently registered in the system.',
              style: PMT.appStyle(
                size: 12,
                fontWeight: FontWeight.w400,
                fontColor: Colors.blue[800]!,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
