import 'package:get/get.dart';
import 'controller.dart';

final FirestoreController fc = Get.find();

updateUrl(var link, String docid) async {
  try {
    await fc.userCollection.doc(docid).update({
      'PhotoURL': link,
    }).then((value) {
      Get.snackbar("Uploaded!", "Image uploaded Successfully.");
    });
  } catch (e) {
    print("Update Data Error:" + e.toString());
  }
}

updateDeletedImgUrl(String docId) async {
  try {
    await fc.userCollection.doc(docId).update({
      'PhotoURL': '',
    }).then((value) {
      Get.snackbar("Success!", "Image Deleted Successfully.");
    });
  } catch (e) {
    print('Link Deletion Error:' + e.toString());
  }
}
