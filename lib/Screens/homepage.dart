import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/app_controller.dart';
import '../Auth_Service/auth_controller.dart';
import '../Auth_Service/auth_service.dart';
import '../Themes/theme_controller.dart';
import '../widgets/alertbox.dart';
import '../FirebaseStorage/add_picture.dart';
import '../FirebaseStorage/add_picture_web.dart';
import '../Cloud_Firestore/controller.dart';
import '../Cloud_Firestore/select_data.dart';
import '../Cloud_Firestore/update_data.dart';
import './main_page.dart';

// authentication services controller
final AuthController c = Get.find();
// authentication services
final AuthService a = AuthService();
// theme controller
final ThemeController t = Get.find();
// application controller
final AppController controller = Get.put(AppController());
final FirestoreController fc = Get.put(FirestoreController());

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    selectData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // title of the screen
    t.title.value = "Welcome:" + c.user.displayName;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.title.value, style: TextStyle(color: t.getForeground)),
        centerTitle: true,
        actions: [
          // Logout Icon button
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              try {
                // calling the logout funtion
                a.signOutGoogle().then((value) {
                  /*  enroute to Main Page. 
                  Get.offAll() will clear all the instances of the previous routes/screens. It basically replace an existing route. */
                  fc.docId.value = '';
                  fc.photo.value = '';
                  print(
                      'fc.docId.value: ${fc.docId.value}\n fc.photo.value: ${fc.photo.value}');
                  Get.offAll(Mainpage());
                  c.message("Success!", "User Signed Out");
                });
              } catch (e) {
                print(" Err: " + e.toString());
                c.message("Attention", e.toString());
              }
            },
          ),
          IconButton(
            icon: Icon(t.b_icon.value),
            onPressed: () => t.changeMode(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Wrap(
          spacing: 8.0,
          runSpacing: 5.0,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.transparent,
                  child: Obx(() => ClipOval(
                        child: (fc.photo.value != ''
                            ? Image.network(
                                fc.photo.value,
                                width: 150.0,
                                height: 150.0,
                                fit: BoxFit.fill,
                              )
                            : Image.network(
                                c.user.photoURL,
                                width: 150.0,
                                height: 150.0,
                                fit: BoxFit.fill,
                              )),
                      )),
                ),
                Column(
                  children: [
                    IconButton(
                      tooltip: 'Add Picture',
                      icon: Icon(Icons.camera_alt_outlined),
                      onPressed: () {
                        try {
                          if (GetPlatform.isDesktop || GetPlatform.isWeb) {
                            uploadImageWeb(fc.photo.value, fc.docId.value);
                            selectData();
                          } else {
                            uploadImage(fc.photo.value, fc.docId.value);
                            selectData();
                          }
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
                            updateDeletedImgUrl(fc.docId.value);
                            fc.docId.value = '';
                            fc.photo.value = '';
                            // deleteImage(_docId, _imageUrl);
                          } catch (e) {
                            print('Delete Picture onPressed Error: ' +
                                e.toString());
                          }
                        }),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        // Delete Account Button
        IconButton(
          icon: Icon(
            Icons.delete_forever_outlined,
            color: t.getBackground,
            // size: 50,
          ),
          onPressed: () {
            try {
              alertDialogBox(context, fc.docId.value);
              fc.docId.value = '';
              fc.photo.value = '';
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
