import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Auth_Service/auth_controller.dart';
import '../Auth_Service/auth_service.dart';
import '../Screens/homepage.dart';
import './loginscreen.dart';

class Mainpage extends StatefulWidget {
  @override
  _MainpageState createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  // authentication services controller
  final AuthController c = Get.put(AuthController());
  // authentication services
  final AuthService as = AuthService();
  bool login = false;
  check() async {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('not logged in: ' + user.toString());
        login = false;
        print(login);
        // c.authSignIn.value = false;
      } else if (user != null) {
        print('logged in: ' + user.toString());
        login = true;
        // c.authSignIn.value = true;
      }
    });
  }

  @override
  void initState() {
    try {
      check();
      //check if user is already logged in the system or not
      // as.checkAutoLogin().then((value) {
      // print(value);
      // if (value == 'null') {
      //   print(c.authSignIn.value);
      //   c.authSignIn.value = false;
      // } else if (value != null) {
      //   c.authSignIn.value = true;
      // } else {
      //   c.authSignIn.value = false;
      // }
      // });
    } catch (e) {
      print("Error:" + e.toString());
      c.message("Attention", e.toString());
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    as.checkAutoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return (login == false ? LoginScreen() : Home());
  }
}
