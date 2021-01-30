import 'package:get/get.dart';
import './controller.dart';

final FirestoreController fc = Get.find();

deleteDocument(String docid) async {
  try {
    await fc.userCollection.doc(docid).delete().then((value) {
      Get.snackbar("Deleted!", "Data deleted successfully.");
    });
  } catch (e) {
    print("Delete Document Error:" + e.toString());
  }
}