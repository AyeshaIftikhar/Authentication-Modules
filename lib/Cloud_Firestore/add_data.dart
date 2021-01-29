import 'package:flutter_codes/Auth_Service/auth_controller.dart';
import 'package:get/get.dart';
import 'controller.dart';

final AuthController c = Get.find();
final FirestoreController fc = Get.find();

addData(var link) async {
  try {
    await fc.userCollection.add({
      'user id': c.user.uid,
      'Name': c.user.displayName,
      'Email': c.user.email,
      'PhotoURL': link,
    }).then((value) {
      Get.snackbar("Uploaded", "Image uploaded Successfully!");
    });
  } catch (e) {
    print("Cloud Firestore Error:" + e.toString());
  }
}
