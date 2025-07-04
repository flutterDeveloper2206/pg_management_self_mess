import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pg_managment/core/utils/app_network_urls.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/presentation/student_list_screen/student_list_model.dart';

import '../../../ApiServices/api_service.dart';

class StudentListScreenController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<StudentListModel> studentListModel = StudentListModel().obs;

  RxList<Data> studentListSearch = <Data>[].obs;

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getStudentList();
    });
    super.onInit();
  }

  Future searchStudent(String search) async {
    if (search.isEmpty) {
      studentListSearch.value = studentListModel.value.data ?? [];
    } else {
      studentListSearch.value = studentListModel.value.data
              ?.where((element) =>
                  element.name!.toLowerCase().contains(search) ||
                  element.email!.toLowerCase().contains(search) ||
                  element.mobile!.toLowerCase().contains(search) ||
                  element.hostelName!.toLowerCase().contains(search) ||
                  element.roomNo!.toLowerCase().contains(search)
                  )
              .toList() ??
          [];
    }
    update();
  }
  void showDeleteConfirmationDialog(BuildContext context, VoidCallback onYesPressed) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this student?"),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          actionsAlignment: MainAxisAlignment.end,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("No",style: TextStyle(color: Colors.black),),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onYesPressed(); // Callback for yes
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.primary,
              ),
              child: Text("Yes",style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
  }

  Future getStudentList() async {
    isLoading.value = true;

    await ApiService().callGetApi(
        body: {},
        headerWithToken: true,
        showLoader: false,
        url: NetworkUrls.studentListUrl).then((value) async {
      isLoading.value = false;
      if (value != null && value.statusCode == 200) {
        studentListModel.value = StudentListModel.fromJson(value.body);
        studentListSearch.value = studentListModel.value.data ?? [];
      }
    });
  }

  Future deleteStudent(String id) async {
    await ApiService().callDeleteApi(
        body: {},
        headerWithToken: true,
        showLoader: true,
        url: NetworkUrls.studentDeleteUrl + id).then((value) async {
      if (value != null && value.statusCode == 200) {
        getStudentList();
      }
    });
  }
}
