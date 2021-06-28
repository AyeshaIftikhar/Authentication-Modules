import 'package:flutter/material.dart';
import 'package:flutter_codes/Controller/app_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CloudFirestoreService {
  final AppController _app = Get.find();
  Future addUser({@required String docid, @required String type}) async {
    try {
      _app.appUserRef.add({
        'Userid': _app.userid.value,
        'Username': _app.username.value,
        'Email': _app.email.value,
        'ImageUrl': _app.photoUrl.value,
        'profileMode': _app.profileMode.value,
        'signin_type': type,
        'Time': DateTime.now(),
      });
      return true;
    } catch (e) {
      print("Cloud Firestore Error:" + e.toString());
      return false;
    }
  }

  Future selectData() async {
    try {
      await _app.appUserRef
          .where('Userid', isEqualTo: _app.userid.value)
          .get()
          .then((snapshot) {
        _app.docid.value = snapshot.docs[0].id;
        _app.photoUrl.value = snapshot.docs[0].data()['ImageUrl'];
        return true;
      });
    } catch (e) {
      print('Selection Error' + e.toString());
      return false;
    }
  }

  Future updateUrl({@required var link, @required String docid}) async {
    try {
      await _app.appUserRef.doc(docid).update({
        'ImageUrl': link,
      }).then((value) {
        _app.message(title: "Uploaded!", body: "Image uploaded Successfully.");
        return true;
      });
    } catch (e) {
      print("Update Data Error:" + e.toString());
      return false;
    }
  }

  Future updateDeleteUrl({@required String docid}) async {
    try {
      await _app.appUserRef.doc(docid).update({
        'ImageUrl': '',
      }).then((value) async {
        _app.photoUrl.value = '';
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('photoURL', _app.photoUrl.value);
        _app.message(title: "Uploaded!", body: "Image uploaded Successfully.");
        return true;
      });
    } catch (e) {
      print("Update Data Error:" + e.toString());
      return false;
    }
  }

  Future deleteUserDoc({@required String docid}) async {
    try {
      await _app.appUserRef.doc(docid).delete().then((value) {
        _app.message(title: "Deleted!", body: "Data deleted successfully.");
      });
    } catch (e) {
      print("Delete Document Error:" + e.toString());
    }
  }
}
