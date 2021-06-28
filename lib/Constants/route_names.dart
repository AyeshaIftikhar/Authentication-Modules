import 'package:flutter_codes/Screens/homepage.dart';
import 'package:flutter_codes/Screens/loginscreen.dart';
import 'package:flutter_codes/Screens/main_page.dart';
import 'package:flutter_codes/Screens/splash_screen.dart';
import 'package:get/get.dart';

var appPages = [
  GetPage(name: '/', page: ()=> AppSplashScreen()),
  GetPage(name: '/MainPage', page: ()=> Mainpage()),
  GetPage(name: '/LoginScreen', page: ()=> LoginScreen()),
  GetPage(name: '/Home', page: ()=> Home()),
];
