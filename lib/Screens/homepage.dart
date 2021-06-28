import 'package:flutter/material.dart';
import 'package:flutter_codes/Authentication/google_signin_controller.dart';
import 'package:flutter_codes/Cloud_Firestore/cloud_firestore_service.dart';
import 'package:flutter_codes/FirebaseStorage/add_picture.dart';
import 'package:get/get.dart';
import '../Controller/app_controller.dart';
import '../Themes/theme_controller.dart';
import '../widgets/alertbox.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ThemeController _theme = Get.find();
  final AppController _controller = Get.find();
  final GoogleSigninController _googleController = Get.find();
  @override
  void initState() {
    CloudFirestoreService().selectData().then((value) {
      print(_controller.docid.value);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _theme.title.value = "Welcome: ${_controller.username.value}";
    return Scaffold(
      appBar: AppBar(
        title: Text(_theme.title.value,
            style: TextStyle(color: _theme.getForeground)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_theme.b_icon.value),
            onPressed: () => _theme.changeMode(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: Obx(() => Image.network(
                      _controller.photoUrl.value,
                      width: 150.0,
                      height: 150.0,
                      fit: BoxFit.fill,
                    )),
              ),
            ),
            Column(
              children: [
                IconButton(
                  tooltip: 'Add Picture',
                  icon: Icon(Icons.camera_alt_outlined),
                  onPressed: () {
                    try {
                      FirebaseStorageService()
                          .uploadImage(_controller.docid.value);
                    } catch (e) {
                      print('Add Picture onPressed Error: ' + e.toString());
                    }
                  },
                ),
                IconButton(
                    tooltip: 'Delete Picture',
                    icon: Icon(Icons.delete_outlined),
                    onPressed: () {
                      try {
                        CloudFirestoreService()
                            .updateDeleteUrl(docid: _controller.docid.value);
                      } catch (e) {
                        print(
                            'Delete Picture onPressed Error: ' + e.toString());
                      }
                    }),
              ],
            ),
            Column(
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 28.0, top: 10),
                      child: Text(_controller.username.value),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 28.0, top: 10),
                  child: Text(_controller.email.value),
                ),
              ],
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        IconButton(
          icon: Icon(
            Icons.logout,
            color: _theme.getBackground,
          ),
          onPressed: () {
            try {
              _googleController.userSignOut().then((value) {});
            } catch (e) {
              _controller.message(
                  title: 'Something went wrong!',
                  body: 'Please try again later.');
            }
          },
        ),
        IconButton(
          icon: Icon(
            Icons.delete_forever_outlined,
            color: _theme.getBackground,
          ),
          onPressed: () {
            try {
              alertDialogBox(context, _controller.docid.value);
              _controller.docid.value = '';
              _controller.photoUrl.value = '';
            } catch (e) {
              print('Delete Permanently Error:' + e.toString());
            }
          },
          tooltip: "Delete Account ",
        )
      ],
    );
  }
}
