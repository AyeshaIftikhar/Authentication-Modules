import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Auth_Service/auth_service.dart';
import '../Screens/main_page.dart';

// authentication services
final AuthService a = AuthService();

alertDialogBox(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text("Delete Account"),
        content: Text("Are you sure you want to delete account?"),
          actions: [
            FlatButton(
              child: Text("Delete"),
              onPressed: () {
                try {
                  // delete account function
                  a.deleteAccount().then((value) {
                    Get.offAll(Mainpage());
                    Get.snackbar("Success", "Account Deleted");
                  });
                } catch (e) {
                  print("Error:" + e.toString());
                  Get.snackbar("Attention!", e.toString());
                }
              },
            ),
            FlatButton(
              onPressed: () => Get.back(),
              child: Text("Cancel"),
            )
          ],
      );
    }
  );
}
