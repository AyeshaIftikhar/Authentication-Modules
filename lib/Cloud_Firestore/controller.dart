import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FirestoreController extends GetxController {
  final userCollection = FirebaseFirestore.instance.collection("Users");
}
