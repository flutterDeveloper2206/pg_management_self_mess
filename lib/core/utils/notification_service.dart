import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pg_managment/ApiServices/api_service.dart';
import 'package:pg_managment/core/utils/app_network_urls.dart';
import 'package:pg_managment/firebase_options.dart';
import 'package:pg_managment/core/utils/logger.dart';
import 'package:pg_managment/routes/app_routes.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Track if a notification was opened during app launch
  static String? pendingRoute;

  static Future<void> init() async {
    // 1. Request permission (iOS/Android 13+)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      Logger.log('User granted permission');
    } else {
      Logger.log('User declined or has not accepted permission');
    }

    // 2. Initialize Local Notifications for Foreground
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleMessagePayload(response.payload);
      },
    );

    // 3. Create Notification Channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // 4. Get Token
    try {
      String? token = await _firebaseMessaging.getToken();
      Logger.log("FCM Token: $token");
    }catch(e){
      Logger.log("FCM Getting Error: $e");
    }
    // 5. Handle messages
    _initPushNotifications(channel);
  }

  static void _initPushNotifications(AndroidNotificationChannel channel) {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _localNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: android.smallIcon,
              // other properties...
            ),
          ),
          payload: message.data.toString(),
        );
      }
      Logger.log("Foreground message: ${message.notification?.title}");
    });

    // Handle when user taps on notification while app is in background but still running
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessage(message);
    });

    // Handle when app is opened from a terminated state via a notification
    _firebaseMessaging.getInitialMessage().then((message) {
      if (message != null) {
        _handleMessage(message);
      }
    });
  }

  static void _handleMessage(RemoteMessage message) {
    Logger.log("Handling message: ${message.data}");
    pendingRoute = AppRoutes.notificationScreenRoute;
    // Small delay to ensure navigator is ready, especially on launch
    Future.delayed(const Duration(milliseconds: 500), () {
      if (Get.currentRoute != AppRoutes.splashScreenRoute) {
        Get.toNamed(AppRoutes.notificationScreenRoute);
        pendingRoute = null;
      }
    });
  }

  static void _handleMessagePayload(String? payload) {
    Logger.log("Handling notification response payload: $payload");
    pendingRoute = AppRoutes.notificationScreenRoute;
    Future.delayed(const Duration(milliseconds: 500), () {
      if (Get.currentRoute != AppRoutes.splashScreenRoute) {
        Get.toNamed(AppRoutes.notificationScreenRoute);
        pendingRoute = null;
      }
    });
  }

  static Future<String?> getFcmToken() async {
    return await _firebaseMessaging.getToken();
  }

  static Future<void> updateFcmToken() async {
    String? token = await getFcmToken();
    if (token != null) {
      await ApiService().callPostApi(
        body: {'fcm_token': token},
        url: NetworkUrls.updateFcmTokenUrl,
        showLoader: false,
      ).then((value) {
        if (value != null && value.statusCode == 200) {
          Logger.log("FCM Token updated successfully");
        }
      });
    }
  }
}

// Top-level background message handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized for background tasks if you need to use Firebase services like Firestore
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Logger.log("Background message received: ${message.messageId}");
  if (message.notification != null) {
    Logger.log("Background notification: ${message.notification?.title}");
  }
  if (message.data.isNotEmpty) {
    Logger.log("Background message data: ${message.data}");
    // You can use this data to perform background tasks (e.g., updating local DB)
  }
}
