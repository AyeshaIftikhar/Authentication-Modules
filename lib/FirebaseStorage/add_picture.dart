import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_codes/Controller/app_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Cloud_Firestore/cloud_firestore_service.dart';

class FirebaseStorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final AppController _appController = Get.find();
  ImagePicker picker = ImagePicker();
  var _image;
  var pickedFile;

  Future uploadImage(String docid) async {
    print("Current Doc ID: $docid");
    try {
      pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );
      if (pickedFile != null) {
        print(pickedFile.path);
        _image = File(pickedFile.path);
        print(_image);
      } else {
        print("No file Selected");
      }
    } catch (e) {
      print("Image Picker Exception: $e");
      Get.snackbar("Something went wrong!", "Please try again later.");
    }
    // upload to firebase
    try {
      if (_image != null) {
        SettableMetadata metadata = SettableMetadata(
          contentType: 'image',
          cacheControl: 'max-age=60',
          customMetadata: <String, String>{
            'userid': _appController.userid.value,
            'username': _appController.username.value,
          },
        );
        Reference _storageRef = storage.ref().child(
            'ProfilePicture/${_appController.userid.value}/${_appController.username.value}_profilepicture');
        UploadTask _uploadTask;
        if (GetPlatform.isWeb) {
          _uploadTask =
              _storageRef.putData(await pickedFile.readAsBytes(), metadata);
        } else {
          _uploadTask = _storageRef.putFile(_image, metadata);
        }
        TaskSnapshot _tasksnapshot = await _uploadTask;
        // ignore: unused_local_variable
        var link;
        if (_uploadTask != null) {
          link = await _tasksnapshot.ref.getDownloadURL().then((fileUrl) async {
            print("Uploaded Image Link: $fileUrl");
            CloudFirestoreService()
                .updateUrl(link: fileUrl, docid: docid)
                .then((value) async {
              // if (value) {
                _appController.photoUrl.value = fileUrl;
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('photoURL', _appController.photoUrl.value);
                _appController.message(
                    title: "Profile Picture Updated!",
                    body:
                        "Your profile picture has been updated successfully.");
                return true;
              // }
            });
          });
        }
      }
    } catch (e) {
      print('FirebaseStorage Exception: $e');
      return false;
    }
  }
}
