import 'package:pg_managment/core/utils/string_constant.dart';
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
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pg_managment/core/utils/notification_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await PrefUtils.init(); // Initialize it properly before app starts
  if (kIsWeb) {
    PrefUtils.clearPreferencesData();

    PrefUtils.setString(StringConstants.authToken, '');
  }

  // Initialize Notifications
  await NotificationService.init();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

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
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.standard,
      ),
      navigatorKey: NavigationService.navigatorKey,

      //for setting localization strings
      fallbackLocale: Locale('en', 'US'),
      title: 'Self-Mess',
      initialBinding: InitialBindings(),
      initialRoute: AppRoutes.splashScreenRoute,
      getPages: AppRoutes.pages,
    );
  }
}
