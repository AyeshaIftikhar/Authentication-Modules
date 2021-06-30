import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import './Constants/configuration_ids.dart';
import './my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (kIsWeb) {
    // initialiaze the facebook javascript SDK
    FacebookAuth.i.webInitialize(
      appId: facebook_app_id,//<-- YOUR APP_ID
      cookie: true,
      xfbml: true,
      version: "v1.0",
    );
  }
  runApp(MyApp());
}
