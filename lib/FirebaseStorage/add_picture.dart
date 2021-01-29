import 'package:flutter_codes/Auth_Service/auth_controller.dart';
import 'package:flutter_codes/Cloud_Firestore/add_data.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:get/get.dart';
import '../Cloud_Firestore/controller.dart';
import '../Cloud_Firestore/update_data.dart';
import 'dart:io';

final AuthController c = Get.find();
final FirestoreController fc = Get.put(FirestoreController());

uploadImage(String cUrl, String docid) async {
  print('Current Url: $cUrl');
  print("Current Doc ID: $docid");
  final _imgPicker = ImagePicker();
  PickedFile _image; // used while working with image_picker

  // get permissions
  await Permission.photos.request();
  var permissionStatus = await Permission.photos.status;

  // if granted then this module will work
  try {
    if (permissionStatus.isGranted) {
      try {
        _image = await _imgPicker.getImage(source: ImageSource.gallery);
        if (_image != null) {
          uploadFirebase(_image, cUrl, docid).then((value) {
            // print("Returned Link: $value");
            // return value;
          });
        } else {
          Get.snackbar("Pleasa select an image to proceed!", "");
          // return '';
        }
      } catch (e) {
        print('Err:' + e.toString());
      }
    } else if (permissionStatus.isDenied) {
      openAppSettings();
      // return '';
    } else if (permissionStatus.isPermanentlyDenied) {
      openAppSettings();
      // return '';
    } else {
      Get.snackbar("Attention",
          "Permission is not granted, grant the permission first!");
      // return '';
    }
  } catch (e) {
    print('Image Picker Exception:' + e.toString());
  }
  // return '';
}

// upload picture to firebase
uploadFirebase(var image, String curl, String docid) async {
  var file = File(image.path);
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
          .child(c.user.displayName);
      firebase_storage.UploadTask uploadTask =
          reference.putFile(file, metadata);
      var taskSnapshot = await uploadTask;
      if (taskSnapshot != null) {
        var link = await taskSnapshot.ref.getDownloadURL();
        print('Image Link: $link');
        if (curl != null) {
          updateUrl(link, docid);
          fc.photo.value = link;
          // return link.toString();
        } else {
          addData(link);
          fc.photo.value = link;
          // return link.toString();
        }
      }
    } catch (e) {
      print('Firebase Storage Exception:' + e.toString());
    }
  }
  // return '';
}

// firebase_storage.SettableMetadata metadata =
//     firebase_storage.SettableMetadata(
//   cacheControl: 'max-age=60',
//   customMetadata: <String, String>{
//     'userId': c.user.uid,
//   },
// );
// firebase_storage.Reference reference =_fbStorage.ref().child('displayPicture').child(name);
// firebase_storage.UploadTask uploadTask = reference.putFile(file);
// reference.putFile(file, metadata);
// var taskSnapshot = await uploadTask;

// Future<void> getMetadataExample() async {
//   try {
//     firebase_storage.FullMetadata metadata = await firebase_storage
//         .FirebaseStorage.instance
//         .refFromURL('gs://authentication-demo-a1eb6.appspot.com')
//         .child('displayPicture')
//         .getMetadata();
//     // setState(() {
//     // As set in previous example.
//     print(metadata.customMetadata['userId']);
//   } catch (e) {
//     print("Metadata Exception:" + e.toString());
//   }
//   // controller.fsImgUrl.value = metadata.customMetadata['userId'];
//   // });
// }
