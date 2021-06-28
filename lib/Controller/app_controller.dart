import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  Rx<User> user = FirebaseAuth.instance.currentUser.obs;
  RxBool isUserLogin = false.obs;
  RxString username = ''.obs;
  RxString email = ''.obs;
  RxString photoUrl = ''.obs;
  RxString docid = ''.obs;
  RxString userid = ''.obs;
  RxInt profileMode = 0.obs;

  var appUserRef = FirebaseFirestore.instance.collection('Users');

  // will show message to user so that he know that system is  working 
  void message({@required String title, @required String body}) {
    Get.snackbar(title, body);
  }
}
