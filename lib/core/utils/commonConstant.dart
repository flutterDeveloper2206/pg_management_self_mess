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




bool isStudent = false;


}
