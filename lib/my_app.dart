import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './Constants/route_names.dart';
import './Firebase_Analytics/analytics_service.dart';
import './Screens/splash_screen.dart';
import './Themes/app_theme.dart';

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
