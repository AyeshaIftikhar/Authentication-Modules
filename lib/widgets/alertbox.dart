import 'package:flutter/material.dart';
import 'package:flutter_codes/Authentication/google_signin_controller.dart';
import 'package:flutter_codes/Cloud_Firestore/cloud_firestore_service.dart';
import 'package:flutter_codes/Controller/app_controller.dart';
import 'package:get/get.dart';

alertDialogBox(BuildContext context, String docid) {
  final GoogleSigninController _googleController = Get.find();
  final AppController _app = Get.find();
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Delete Account"),
          content: Text("Are you sure you want to delete account?"),
          actions: [
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                try {
                  // delete account function
                  _googleController.deleteAccount().then((value) {
                    if (value) {
                      CloudFirestoreService()
                          .deleteUserDoc(docid: _app.docid.value)
                          .then((val) {
                        if (val) {
                          Get.offAllNamed('/MainPage');
                        }
                      });
                    }
                  });
                } catch (e) {
                  print("Delete Account Error:" + e.toString());
                  _app.message(
                      title: 'Something went wrong!',
                      body: 'Please try again later.');
                }
              },
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: Text("Cancel"),
            )
          ],
        );
      });
}
