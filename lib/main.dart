import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Firebase_Analytics/analytics_service.dart';
import 'Screens/splash_screen.dart';
import 'Themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final AnalyticsService _service = AnalyticsService();
  runApp(
      // setup material app
    GetMaterialApp(
    debugShowCheckedModeBanner: false,
    themeMode: ThemeMode.light,
    theme: theme,
    darkTheme: darktheme,
    home: AppSplashScreen(),
    navigatorObservers: [
        _service.getAnalyticsObserver(),
    ],
    
  ));
}
