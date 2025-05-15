import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pg_managment/ApiServices/api_service.dart';
import 'package:pg_managment/core/utils/app_network_urls.dart';
import 'package:pg_managment/core/utils/navigation_service.dart';
import 'package:pg_managment/core/utils/progress_dialog_utils.dart';
import 'package:pg_managment/presentation/student_list_screen/student_list_model.dart';

class AddStudentScreenController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController hostelNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController roomController = TextEditingController();
  TextEditingController bloodController = TextEditingController();
  TextEditingController currentlyPursuingController = TextEditingController();
  TextEditingController currentlyStudyingYearController =
      TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController alternativeMobileNumberController =
      TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController depositController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController guidController = TextEditingController();

  dynamic argumentData = Get.arguments;

  RxInt isAddEdit = 0.obs;

  RxBool readOnly = false.obs;

  Rx<Data> model = Data().obs;

  Future<void> selectDate(BuildContext context) async {
    print('object');
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2090),
    );

    if (picked != null) {
      String formattedDate =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      dateController.text = formattedDate;
    }
  }

  Future<void> selectYear(BuildContext context) async {
    print('object');
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDatePickerMode: DatePickerMode.year,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2090),
    );

    if (picked != null) {
      String formattedDate = "${picked.year}";
      yearController.text = formattedDate;
    }
  }

  @override
  void onInit() {
    if (argumentData != null) {
      isAddEdit.value = argumentData['isAddEdit'];
      model.value = argumentData['data'];

      if (isAddEdit.value == 2) {
        readOnly.value = true;
      }
    }
    setData();
    super.onInit();
  }

  setData() {
    nameController.text = model.value.name ?? '';
    hostelNameController.text = model.value.hostelName ?? '';
    emailController.text = model.value.email ?? '';
    roomController.text = model.value.roomNo ?? '';
    bloodController.text = model.value.bloodGroup ?? '';
    currentlyPursuingController.text = model.value.currentlyPursuing ?? '';
    currentlyStudyingYearController.text =
        '${model.value.currentlyStudyingYear ?? ''}';
    dateController.text = '${model.value.date ?? ''}';
    yearController.text = '${model.value.year ?? ''}';
    mobileNumberController.text = model.value.mobile ?? '';
    alternativeMobileNumberController.text =
        model.value.alternativeMobile ?? '';
    // passwordController.text= model.value.;
    depositController.text = '${model.value.deposit ?? ''}';
    addressController.text = model.value.residentialAddress ?? '';
    guidController.text = model.value.advisorGuide ?? '';
  }

  Future updateAddStudent({String? id}) async {
    if (isAddEdit.value == 1) {
      await ApiService().callPutApi(
          body: {
            "name": nameController.text,
            "hostel_name": hostelNameController.text,
            "room_no": roomController.text,
            "email": emailController.text,
            "residential_address": addressController.text,
            "currently_pursuing": currentlyPursuingController.text,
            "currently_studying_year": currentlyStudyingYearController.text,
            "date": dateController.text,
            "year": yearController.text,
            "alternative_mobile": alternativeMobileNumberController.text,
            "advisor_guide": guidController.text,
            "blood_group": bloodController.text,
            "deposit": depositController.text,
            "password": passwordController.text

          },
          headerWithToken: true,
          showLoader: true,
          url: NetworkUrls.studentUpdateUrl + id!).then((value) async {
        if (value != null &&
            (value.statusCode == 200 || value.statusCode == 201)) {
          Get.back();

          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            AppFlushBars.appCommonFlushBar(
                context: NavigationService.navigatorKey.currentContext!,
                message: 'Student updated successfully',
                success: true);
          });
        }
      });
    } else {
      await ApiService().callPostApi(
          body: {
            "name": nameController.text,
            "hostel_name": hostelNameController.text,
            "room_no": roomController.text,
            "email": emailController.text,
            "residential_address": addressController.text,
            "currently_pursuing": currentlyPursuingController.text,
            "currently_studying_year":
                int.parse(currentlyStudyingYearController.text),
            "date": dateController.text,
            "year": yearController.text,
            "mobile": mobileNumberController.text,
            "alternative_mobile": alternativeMobileNumberController.text,
            "advisor_guide": guidController.text,
            "blood_group": bloodController.text,
            "deposit": depositController.text,
            "password": passwordController.text
          },
          headerWithToken: true,
          showLoader: true,
          url: NetworkUrls.studentAddUrl).then((value) async {
        if (value != null &&
            (value.statusCode == 200 || value.statusCode == 201)) {
          Get.back();

          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            AppFlushBars.appCommonFlushBar(
                context: NavigationService.navigatorKey.currentContext!,
                message: 'Student added successfully',
                success: true);
          });
        }
      });
    }
  }
}
