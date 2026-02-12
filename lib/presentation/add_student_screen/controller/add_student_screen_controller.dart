import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pg_managment/ApiServices/api_service.dart';
import 'package:pg_managment/core/utils/app_network_urls.dart';
import 'package:pg_managment/core/utils/navigation_service.dart';
import 'package:pg_managment/core/utils/progress_dialog_utils.dart';
import 'package:pg_managment/presentation/student_list_screen/student_list_model.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as p;

class AddStudentScreenController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController hostelNameController = TextEditingController();
  TextEditingController registrationNumberController = TextEditingController();
  TextEditingController collageNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController roomController = TextEditingController();
  TextEditingController bloodController = TextEditingController();
  TextEditingController academicProgramController = TextEditingController();
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

  final ImagePicker _picker = ImagePicker();
  Rx<XFile?> selectedImage = Rx<XFile?>(null);
  RxString profileImageUrl = "".obs;

  dynamic argumentData = Get.arguments;

  RxInt isAddEdit = 0.obs;

  RxBool readOnly = false.obs;
  RxBool isStudentShow = false.obs;

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
      isStudentShow.value = argumentData['isStudentShow'] ?? false;
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
    registrationNumberController.text = model.value.registrationNumber ?? '';
    collageNameController.text = model.value.collageName ?? '';
    emailController.text = model.value.email ?? '';
    roomController.text = model.value.roomNo ?? '';
    bloodController.text = model.value.bloodGroup ?? '';
    academicProgramController.text = model.value.currentlyPursuing ?? '';
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
    profileImageUrl.value = model.value.profileImage ?? '';
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        ProgressDialogUtils.showProgressDialog();
        final compressedImage = await _compressImage(image);
        ProgressDialogUtils.hideProgressDialog();

        if (compressedImage != null) {
          selectedImage.value = compressedImage;
        } else {
          selectedImage.value = image;
        }
      }
    } catch (e) {
      ProgressDialogUtils.hideProgressDialog();
      print("Error picking image: $e");
    }
  }

  Future<XFile?> _compressImage(XFile file) async {
    final tempDir = await path_provider.getTemporaryDirectory();
    final path = tempDir.path;
    final outPath = p.join(
      path,
      "${DateTime.now().millisecondsSinceEpoch}_compressed.jpg",
    );

    int quality = 90;
    XFile? result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      outPath,
      quality: quality,
    );

    if (result == null) return null;

    // Recursive compression if size > 300 KB
    while (quality > 10) {
      final int length = await result!.length();
      if (length <= 300 * 1024) break;

      quality -= 10;
      final newResult = await FlutterImageCompress.compressAndGetFile(
        file.path,
        outPath,
        quality: quality,
      );
      if (newResult == null) break;
      result = newResult;
    }

    return result;
  }

  Future updateAddStudent({String? id}) async {
    const pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    final regex = RegExp(pattern);
    if (emailController.text.isEmpty) {
      AppFlushBars.appCommonFlushBar(
        context: NavigationService.navigatorKey.currentContext!,
        message: 'Enter Your Email',
        success: false,
      );
      return;
    } else if (!regex.hasMatch(emailController.text)) {
      AppFlushBars.appCommonFlushBar(
        context: NavigationService.navigatorKey.currentContext!,
        message: 'Enter a Valid Email',
        success: false,
      );

      return;
    } else {
      Map<String, dynamic> bodyMap = {
        "name": nameController.text,
        "hostel_name": hostelNameController.text,
        "registration_no": registrationNumberController.text,
        "college_name": collageNameController.text,
        "room_no": roomController.text,
        "email": emailController.text,
        "residential_address": addressController.text,
        "currently_pursuing": academicProgramController.text,
        "currently_studying_year": currentlyStudyingYearController.text,
        "date": dateController.text,
        "year": yearController.text,
        "alternative_mobile": alternativeMobileNumberController.text,
        "advisor_guide": guidController.text,
        "blood_group": bloodController.text,
        "deposit": depositController.text,
        "password": passwordController.text,
      };

      if (mobileNumberController.text.isNotEmpty) {
        bodyMap["mobile"] = mobileNumberController.text;
      }

      if (selectedImage.value != null) {
        bodyMap["profile_image"] = MultipartFile(
          selectedImage.value!.path,
          filename: selectedImage.value!.name,
        );
      }

      if (isAddEdit.value == 1) {
        bodyMap["_method"] = "PUT";
        await ApiService()
            .callPostApi(
              body: FormData(bodyMap),
              headerWithToken: true,
              showLoader: true,
              url: NetworkUrls.studentUpdateUrl + id!,
            )
            .then((value) async {
              if (value != null &&
                  (value.statusCode == 200 || value.statusCode == 201)) {
                Get.back();

                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  AppFlushBars.appCommonFlushBar(
                    context: NavigationService.navigatorKey.currentContext!,
                    message: 'Student updated successfully',
                    success: true,
                  );
                });
              }
            });
      } else {
        await ApiService()
            .callPostApi(
              body: FormData(bodyMap),
              headerWithToken: true,
              showLoader: true,
              url: NetworkUrls.studentAddUrl,
            )
            .then((value) async {
              if (value != null &&
                  (value.statusCode == 200 || value.statusCode == 201)) {
                Get.back();

                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  AppFlushBars.appCommonFlushBar(
                    context: NavigationService.navigatorKey.currentContext!,
                    message: 'Student added successfully',
                    success: true,
                  );
                });
              }
            });
      }
    }
  }
}
