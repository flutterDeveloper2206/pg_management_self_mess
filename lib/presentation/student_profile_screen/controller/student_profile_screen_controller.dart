import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pg_managment/ApiServices/api_service.dart';
import 'package:pg_managment/core/utils/app_network_urls.dart';
import 'package:pg_managment/core/utils/navigation_service.dart';
import 'package:pg_managment/core/utils/pref_utils.dart';
import 'package:pg_managment/core/utils/progress_dialog_utils.dart';
import 'package:pg_managment/core/utils/string_constant.dart';
import 'package:pg_managment/presentation/student_profile_screen/student_profile_model.dart';

class StudentProfileScreenController extends GetxController {
  Rx<StudentProfileModel> model = StudentProfileModel().obs;
  RxBool isLoading = false.obs;
  final ImagePicker _picker = ImagePicker();
  Rx<XFile?> selectedImage = Rx<XFile?>(null);

  @override
  void onInit() {
    if (Get.arguments != null && Get.arguments['studentId'] != null) {
      getStudentProfile(studentId: Get.arguments['studentId']);
    } else if (Get.arguments != null && Get.arguments['data'] != null) {
      // If full data is passed, we can populate it immediately
      // but still fetch to ensure it's fresh if needed.
      // For now let's just use the ID from data to fetch.
      getStudentProfile(studentId: Get.arguments['data'].id.toString());
    } else {
      getStudentProfile();
    }
    super.onInit();
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 70,
      );
      if (image != null) {
        selectedImage.value = image;
        uploadProfileImage();
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> uploadProfileImage() async {
    if (selectedImage.value == null) return;

    final String studentId =
        model.value.data?.id.toString() ??
        PrefUtils.getString(StringConstants.studentId);

    if (studentId.isEmpty) return;

    try {
      FormData formData = FormData({
        'profile_image': MultipartFile(
          selectedImage.value!.path,
          filename: selectedImage.value!.name,
        ),
        '_method':
            'PUT', // Some Laravel APIs require _method: PUT in POST for multipart PUT
      });

      // Using POST with _method: PUT or just PUT if supported
      await ApiService()
          .callPostApi(
            body: formData,
            headerWithToken: true,
            showLoader: true,
            url: '${NetworkUrls.studentUpdateUrl}$studentId',
          )
          .then((value) async {
            if (value.statusCode == 200 || value.statusCode == 201) {
              AppFlushBars.appCommonFlushBar(
                context: NavigationService.navigatorKey.currentContext!,
                message: 'Profile image updated successfully',
                success: true,
              );
              getStudentProfile(studentId: studentId);
            } else {
              AppFlushBars.appCommonFlushBar(
                context: NavigationService.navigatorKey.currentContext!,
                message: 'Failed to update profile image',
                success: false,
              );
            }
          });
    } catch (error) {
      AppFlushBars.appCommonFlushBar(
        context: NavigationService.navigatorKey.currentContext!,
        message: error.toString(),
        success: false,
      );
    }
  }

  Future<void> getStudentProfile({String? studentId}) async {
    isLoading.value = true;

    final String idToFetch =
        studentId ?? PrefUtils.getString(StringConstants.studentId);

    try {
      await ApiService()
          .callGetApi(
            body: FormData({}),
            headerWithToken: true,
            showLoader: true,
            url: '${NetworkUrls.studentProfile}$idToFetch',
          )
          .then((value) async {
            if (value.statusCode == 200) {
              isLoading.value = false;
              model.value = StudentProfileModel.fromJson(value.body);
            } else {
              isLoading.value = false;

              AppFlushBars.appCommonFlushBar(
                context: NavigationService.navigatorKey.currentContext!,
                message: 'Something went wrong',
                success: false,
              );
            }
          });
    } catch (error) {
      isLoading.value = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppFlushBars.appCommonFlushBar(
          context: NavigationService.navigatorKey.currentContext!,
          message: error.toString(),
          success: false,
        );
      });
    }
  }
}
