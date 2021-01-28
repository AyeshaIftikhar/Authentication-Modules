import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  // object for google signin
  final GoogleSignIn googleSignIn = GoogleSignIn();
  //firebase authentication object
  final FirebaseAuth auth = FirebaseAuth.instance;
  // google account used for signing by user
  GoogleSignInAccount account;
  // firebase user to access and store data of authenticated user in firebase
  User user;
  // for checking signin status for auto signing of a user
  RxBool authSignIn = false.obs;

  // will show message to user so that he know that system is  working 
  void message(String title, String body) {
    Get.snackbar(title, body);
  }
}
