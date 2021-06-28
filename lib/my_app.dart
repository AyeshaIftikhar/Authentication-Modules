import 'package:flutter/material.dart';
import 'package:flutter_codes/Constants/route_names.dart';
import 'package:flutter_codes/Firebase_Analytics/analytics_service.dart';
import 'package:flutter_codes/Screens/splash_screen.dart';
import 'package:flutter_codes/Themes/app_theme.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);
  final AnalyticsService _service = AnalyticsService();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      getPages: appPages,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: theme,
      darkTheme: darktheme,
      home: AppSplashScreen(),
      navigatorObservers: [
        _service.getAnalyticsObserver(),
      ],
    );
  }
}
