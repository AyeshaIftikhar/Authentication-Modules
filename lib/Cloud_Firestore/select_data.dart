import 'package:get/get.dart';
import '../Auth_Service/auth_controller.dart';
import './controller.dart';

final FirestoreController fc = Get.put(FirestoreController());
final AuthController c = Get.find();

selectData() async {
  try {
    await fc.userCollection
        .where('user id', isEqualTo: c.user.uid)
        .get()
        .then((snapshot) {
      fc.docId.value = snapshot.docs[0].id;
      fc.photo.value = snapshot.docs[0].data()['PhotoURL'];
    });
  } catch (e) {
    print('Selection Error' + e.toString());
  }
}
