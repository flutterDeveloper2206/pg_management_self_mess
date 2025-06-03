
import 'package:pg_managment/core/utils/pref_utils.dart';
import 'package:pg_managment/packages/OverlayLoading/lib/loader_overlay.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/initial_bindings.dart';
import 'package:pg_managment/localization/app_localization.dart';
import 'package:pg_managment/routes/app_routes.dart';
import 'package:pg_managment/widgets/error_screen.dart';

import 'core/utils/logger.dart';
import 'core/utils/navigation_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefUtils.init(); // Initialize it properly before app starts

  ErrorWidget.builder =
      (FlutterErrorDetails details) => AppFlutterErrorScreen(details: details);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) {
    Logger.init(kReleaseMode ? LogMode.live : LogMode.debug);
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          visualDensity: VisualDensity.standard,
        ),
        translations: AppLocalization(),
        navigatorKey:
             NavigationService.navigatorKey,

        //for setting localization strings
        fallbackLocale: Locale('en', 'US'),
        title: 'Self-Mess',
        initialBinding: InitialBindings(),
        initialRoute: AppRoutes.splashScreenRoute,
        getPages: AppRoutes.pages,

    );
  }
}
