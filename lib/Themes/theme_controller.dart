import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController{
  RxString title = "Flutter Codes".obs;
    // ignore: non_constant_identifier_names
  var s_icon = Icons.wb_sunny.obs;
  // ignore: non_constant_identifier_names
  var b_icon = Icons.nights_stay_rounded.obs;
  var darktheme = true;
  var background =Colors.cyan.obs; 
  var foreground = Colors.white.obs;
  var textcolor = Colors.black.obs;

  // getter for easy use of variables
  get getBackground => this.background.value;
  get getForeground => this.foreground.value; 
  get gettextColor => this.textcolor.value;
  get getdarkTheme => this.darktheme;
  set setIcon(IconData icon) => this.b_icon.value = icon;
  IconData get getIcon => this.b_icon.value;

  // function to change theme 
  void changeMode() {
    if (darktheme) {
      Get.changeThemeMode(ThemeMode.dark);
      foreground.value = Colors.white;
      textcolor.value = Colors.white;
      darktheme = !darktheme;
      setIcon = Icons.wb_sunny;
    } else {
      Get.changeThemeMode(ThemeMode.light);
      foreground.value = Colors.black;
      textcolor.value = Colors.black;
      darktheme = !darktheme;
      setIcon = Icons.nights_stay_rounded;
    }
  }
}
