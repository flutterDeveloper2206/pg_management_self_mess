import 'dart:io';

import 'package:pg_managment/core/utils/progress_dialog_utils.dart';
import 'package:pg_managment/packages/OverlayLoading/lib/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'navigation_service.dart';



class CommonConstant {
  CommonConstant._();

  String mapApiKey = '';

  static final instance = CommonConstant._();
  String? getCurrentRoute() {
    String? currentRoute = null;
    NavigationService.navigatorKey.currentState?.popUntil((route) {
      currentRoute = route.settings.name;
      return true;
    });
    return currentRoute;
  }

  Future<File> showImagePickBottomSheet(context, {bool isDismissible = true,void Function()? onPressedDelete }) async {
    final ImagePicker picker = ImagePicker();

    File file = File('');
    await showModalBottomSheet(
      isDismissible: isDismissible,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        'Choose Anyone',
                        style: TextStyle(
                            color: Colors.blueGrey.shade500, fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Spacer(),
                      if(onPressedDelete!=null)
                        IconButton(onPressed: onPressedDelete, icon: Icon(Icons.delete))
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            XFile? pickedFile;
                            pickedFile = await picker.pickImage(
                              imageQuality: 25,
                              source: ImageSource.camera,
                            );
                            if (pickedFile != null) {
                              startLoadingOverlay();
                              String path = await cropImage(pickedFile);
                              file = File(path);
                            } else {
                              AppFlushBars.appCommonFlushBar(context: NavigationService.navigatorKey.currentState!.context, message: 'Image Not Saved!', success: false);

                            }
                            setState(() {});
                            await Future.delayed(Duration(seconds: 2), () {
                              Navigator.pop(NavigationService.navigatorKey.currentState!.context);
                            });
                            stopLoadingOverlay();
                          },
                          child: Column(
                            children: [
                              Card(
                                child: CircleAvatar(
                                    radius: 35,
                                    backgroundColor: Colors.transparent,
                                    child: Icon(
                                      Icons.linked_camera,
                                      color: Colors.black,
                                      size: 30,
                                    )),
                              ),
                              Text(
                                'Camera',
                                style: TextStyle(
                                    color: Colors.blueGrey.shade500,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            XFile? pickedFile;
                            pickedFile = await picker.pickImage(
                              imageQuality: 25,
                              source: ImageSource.gallery,
                            );
                            if (pickedFile != null) {
                              startLoadingOverlay();
                              String path = await cropImage(pickedFile);
                              file = File(path);
                            } else {
                              AppFlushBars.appCommonFlushBar(context: NavigationService.navigatorKey.currentState!.context, message: 'Image Not Saved!', success: false);

                            }
                            setState(() {});
                            await Future.delayed(Duration(seconds: 2), () {
                              Navigator.pop(NavigationService.navigatorKey.currentState!.context);
                            });
                            stopLoadingOverlay();
                          },
                          child: Column(
                            children: [
                              Card(
                                child: CircleAvatar(
                                    radius: 35,
                                    backgroundColor: Colors.transparent,
                                    child: Icon(
                                      Icons.photo,
                                      color: Colors.black,
                                      size: 30,
                                    )),
                              ),
                              Text(
                                'Gallery',
                                style: TextStyle(
                                    color: Colors.blueGrey.shade500,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    return file;
  }



  Future<String> cropImage(XFile? pickedFile) async {
    if (pickedFile == null) return '';

    File originalFile = File(pickedFile.path);
    print('Original File Size: ${originalFile.lengthSync() / 1024 / 1024} MB');

    // 🔹 Step 1: Pre-compress before cropping (prevents crash for large images)
    originalFile = await compressImage(originalFile, 4 * 1024 * 1024); // Reduce to ~4MB

    // 🔹 Step 2: Crop Image (using compressed file)
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: originalFile.path, // Use the **compressed** file
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100, // Keep high quality
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: Colors.blue,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
      ],
    );

    if (croppedFile == null) return '';

    File croppedImageFile = File(croppedFile.path);
    print('Cropped File Size: ${croppedImageFile.lengthSync() / 1024 / 1024} MB');

    // 🔹 Step 3: Final Compression (Target: **Under 1MB**)
    File compressedFile = await compressImage(croppedImageFile, 1024 * 1024);

    return compressedFile.path;
  }


// 🔹 Compress Image Before Cropping to Prevent Crashes
  Future<File> compressImage(File file, int maxSize) async {
    int quality = 90; // Start with high quality
    int minQuality = 10; // Prevents excessive quality loss
    int step = 10;

    File compressedFile = file;

    // 🔹 If file is already under the max size, return it immediately
    if (compressedFile.lengthSync() <= maxSize) {
      print('No compression needed');
      return compressedFile;
    }

    while (compressedFile.lengthSync() > maxSize && quality > minQuality) {
      File? tempCompressed = await _compressFile(compressedFile, quality);
      if (tempCompressed != null && tempCompressed.lengthSync() < compressedFile.lengthSync()) {
        compressedFile = tempCompressed;
      }
      quality -= step;
    }

    print('Final Compressed File Size: ${compressedFile.lengthSync() / 1024 / 1024} MB');
    return compressedFile;
  }


  Future<File?> _compressFile(File file, int quality) async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String targetPath = '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

      XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
        minWidth: 1080, // Reducing resolution more aggressively
        minHeight: 720,
      );

      if (compressedFile != null) {
        return File(compressedFile.path);
      }
    } catch (e) {
      debugPrint("Compression failed: $e");
    }
    return null;
  }

  startLoadingOverlay() async {
    NavigationService.navigatorKey.currentState!.context.loaderOverlay.show();
  }

  stopLoadingOverlay() {
    NavigationService.navigatorKey.currentState!.context.loaderOverlay.hide();
  }






}
