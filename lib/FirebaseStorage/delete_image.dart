// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:flutter_codes/Cloud_Firestore/update_data.dart';

// Future<void> deleteImage(String docid, String img) async {
//   print('Image Url to be Deleted: $img');
//   try {
//     String filePath = img.replaceAll(
//         RegExp(
//             r'https://firebasestorage.googleapis.com/v0/b/authentication-demo-a1eb6.appspot.com/o/'),
//         "");
//     print(filePath);
//     filePath = filePath.replaceAll(RegExp(r'%2F'), '/');
//     print(filePath);
//     filePath = filePath.replaceAll(RegExp(r'(\?alt).*'), '');
//     print(filePath);
//     firebase_storage.Reference reference =
//         firebase_storage.FirebaseStorage.instance.ref();
//     await reference.child(filePath).delete().then((value) {
//       updateDeletedImgUrl(docid);
//     });
//     // firebase_storage.Reference reference =
//     //     firebase_storage.FirebaseStorage.instance.refFromURL(img);
//     // await reference.delete().then((delReference) {
//     //   updateDeletedImgUrl(docid);
//     // });
//   } catch (e) {
//     print('Firebase Storage Image Deletion Error:' + e.toString());
//   }
// }
