import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_codes/Screens/splash_screen.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'Firebase_Analytics/analytics_service.dart';
import 'Themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // final CloudMessagingService cm = CloudMessagingService();
  // FirebaseMessaging.onBackgroundMessage(cm.firebaseMessagingBackgroundHandler);
  final AnalyticsService _service = AnalyticsService();
  // OneSignal
  //Remove this method to stop OneSignal Debugging 
  // OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  // OneSignal.shared.init('48e4de18-1433-495d-b6a0-9d2fff414892');
  // OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  // await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
  runApp(
      // setup material app
  GetMaterialApp(
    debugShowCheckedModeBanner: false,
    themeMode: ThemeMode.light,
    theme: theme,
    darkTheme: darktheme,
    // home: MyApp(),
    home: AppSplashScreen(),
    navigatorObservers: [
      _service.getAnalyticsObserver(),
    ],
  ));
}
