import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Auth_Service/auth_controller.dart';
import '../Auth_Service/auth_service.dart';
import '../Themes/theme_controller.dart';
import './homepage.dart';



class LoginScreen extends StatelessWidget {
  // Authentication Services Controller
final AuthController c = Get.put(AuthController());
// Authentication Services
final AuthService as = AuthService();
// Theme Controller 
final ThemeController t = Get.put(ThemeController());
  @override
  Widget build(BuildContext context) {
    t.title.value = "Flutter Codes";
    return Scaffold(
      appBar: AppBar(
        title: Text(t.title.value, style: TextStyle(color: t.getForeground)),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(t.b_icon.value),
            onPressed: () => t.changeMode(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            ElevatedButton.icon(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.all(20.0)),
                ),
                icon: FaIcon(FontAwesomeIcons.google, color: t.getForeground),
                onPressed: () {
                  try {
                    // custom events
                    FirebaseAnalytics().logEvent(name: 'Login',parameters:null);
                    // signed in function 
                    as.googleSignIn().then((result) {
                      if (result != null) {
                        try {
                          // set the shared preferences
                          as.login().then((value) {
                            Get.off(Home());
                            c.message("Success", "User Signed In.");
                          });
                        } catch (e) {
                          print("Error:" + e.toString());
                          c.message("Attention", e.toString());
                        }
                      }
                    });
                  } catch (e) {
                    print('Error: ' + e.toString());
                    c.message("Attention", e.toString());
                  }
                },
                label: Text(
                  'Sign in via Google',
                  style: TextStyle(color: t.getForeground),
                ))
          ],
        )),
    );
  }
}
