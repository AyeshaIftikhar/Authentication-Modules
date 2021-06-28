import 'package:flutter/material.dart';
import 'package:flutter_codes/Authentication/google_signin_controller.dart';
import 'package:flutter_codes/Controller/app_controller.dart';
import 'package:flutter_codes/Screens/loginscreen.dart';
import 'package:flutter_codes/Themes/theme_controller.dart';
import 'package:get/get.dart';
import './homepage.dart';

class Mainpage extends StatefulWidget {
  @override
  _MainpageState createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  // ignore: unused_field
  final ThemeController _theme = Get.put(ThemeController());
  final AppController _controller = Get.put(AppController());
  final GoogleSigninController _googleSigninController =
      Get.put(GoogleSigninController());
  @override
  void initState() {
    super.initState();
    _googleSigninController.checkUserLoginStatus().then((value) {
      print(_controller.isUserLogin.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          child: _controller.isUserLogin.value ? Home() : LoginScreen(),
        ));
  }
}
