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

  bool checkLogin() {
    bool login;
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user.isBlank) {
        print('not logged in: ' + user.toString());
        login = false;
      } else {
        print('logged in: ' + user.toString());
        login = true;
      }
    });
    return login;
  }

  @override
  void initState() {
    // try {
    //   checkLogin();
    //   // check if user is already logged in the system or not
    // } catch (e) {
    //   print("Error:" + e.toString());
    //   c.message("Attention", e.toString());  
      
    // }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    as.checkAutoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return (checkLogin() ? LoginScreen() : Home());
  }
}
