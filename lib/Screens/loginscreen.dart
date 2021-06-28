import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_codes/Authentication/google_signin_controller.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Themes/theme_controller.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ThemeController _theme = Get.find();
  final GoogleSigninController _googleSigninController = Get.find();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme.title.value = "Flutter Codes";
    return Scaffold(
      appBar: AppBar(
        title: Text(_theme.title.value,
            style: TextStyle(color: _theme.getForeground)),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(_theme.b_icon.value),
            onPressed: () => _theme.changeMode(),
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
              icon:
                  FaIcon(FontAwesomeIcons.google, color: _theme.getForeground),
              onPressed: () {
                try {
                  // custom events
                  FirebaseAnalytics().logEvent(name: 'Login', parameters: null);
                  // signed in function
                  _googleSigninController.userSignIn().then((value) {
                    // print(value);
                    // if (value) {
                    //   Get.toNamed('/Home');
                    // }
                  });
                } catch (e) {
                  print('Error: ' + e.toString());
                }
              },
              label: Text(
                'Sign in via Google',
                style: TextStyle(color: _theme.getForeground),
              )),
        ],
      )),
    );
  }
}
