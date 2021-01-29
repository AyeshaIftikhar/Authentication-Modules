// import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_codes/Auth_Service/auth_controller.dart';
import 'package:flutter_codes/Cloud_Firestore/add_data.dart';
import 'package:flutter_codes/Cloud_Firestore/controller.dart';
import 'package:flutter_codes/Cloud_Firestore/update_data.dart';
import '../Controller/app_controller.dart';
import 'package:get/get.dart';

final AppController controller = Get.find();

/// A "select file/folder" window will appear. User will have to choose a file.
/// This file will be then read, and uploaded to firebase storage;
uploadImageWeb(String curl, String docid) async {
  print('Current Picture Link: $curl');
  print('Current Document ID: $docid');
  try {
    FilePickerResult result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: [
          'jpg',
          'png',
        ]);
    if (result != null) {
      Uint8List _img = result.files.single.bytes;
      uploadToFirebase(_img, curl, docid).then((value) {
        print('Returned Link: $value');
        // return value;
      });
    } else {
      Get.snackbar("Please select an image to proceed.", "");
      // return '';
    }
  } catch (e) {
    print('Image Picker Error:' + e.toString());
  }
  // return '';
}

final AuthController c = Get.find();
final FirestoreController fc= Get.put(FirestoreController());

uploadToFirebase(var image, String curl, String docid) async {
  if (image != null) {
    try {
      firebase_storage.SettableMetadata metadata =
          firebase_storage.SettableMetadata(
        cacheControl: 'max-age=60',
        customMetadata: <String, String>{
          'userId': c.user.uid,
        },
      );
      firebase_storage.Reference reference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child(c.user.uid)
          .child('${c.user.displayName}.png');
      firebase_storage.UploadTask uploadTask =
          reference.putData(image, metadata);
      var taskSnapshot = await uploadTask;
      if (taskSnapshot != null) {
        var link = await taskSnapshot.ref.getDownloadURL();
        print('Image Link: $link');
        if (curl != null) {
          updateUrl(link, docid);
          fc.photo.value = link;
          // return link;
        } else {
          addData(link);
          fc.photo.value = link;
          // return link;
        }
      }
    } catch (e) {
      print("Uploading Error:" + e.toString());
    }
  }
}
