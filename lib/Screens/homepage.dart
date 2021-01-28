import 'package:auth_demo/Controller/app_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../Auth_Service/auth_controller.dart';
import '../Auth_Service/auth_service.dart';
import '../Themes/theme_controller.dart';
import '../widgets/alertbox.dart';
import './main_page.dart';
import 'FirebaseStorage/android_ios_implementation.dart';
import 'FirebaseStorage/web_implementation.dart';

// authentication services controller
final AuthController c = Get.find();
// authentication services
final AuthService a = AuthService();
// theme controller
final ThemeController t = Get.find();
// application controller
final AppController controller = Get.put(AppController());

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // String _imageUrl;

  getProfilePictureWeb() async {
    try {
      FirebaseFirestore.instance
          .collection("UserDisplayPicture")
          .where('User Id', isEqualTo: controller.userid)
          .get()
          .then((snapshot) {
        setState(() {
          controller.fsImgUrl.value = snapshot.docs[0].data()['Pic Link'];
          print(controller.fsImgUrl.value);
        });
      });
    } catch (e) {
      print('URL Error:' + e.toString());
    }
  }

  getProfilePicture() async {
    try {
      final ref = FirebaseStorage.instance
          .refFromURL('gs://authentication-demo-a1eb6.appspot.com')
          .child('displayPicture/');
      // no need of the file extension, the name will do fine.
      await ref.getDownloadURL().then((url) {
        setState(() {
          print(url);
          controller.fsImgUrl.value = url;
          // _imageUrl = url;
          print(controller.fsImgUrl.value);
        });
      });
    } catch (e) {
      print("URL Exception:" + e.toString());
    }
  }

  @override
  void initState() {
    if (GetPlatform.isWeb || GetPlatform.isDesktop) {
      getProfilePictureWeb();
    } else {
      getProfilePicture();
    }
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
                  child: ClipOval(
                    child: (controller.fsImgUrl.value != null
                        ? Image.network(
                            controller.fsImgUrl.value,
                            fit: BoxFit.fill,
                          )
                        : Image.network(
                            controller.img,
                            fit: BoxFit.fill,
                          )),
                  ),
                ),
                IconButton(
                  tooltip: 'Add Picture',
                  icon: Icon(Icons.camera_alt_outlined),
                  onPressed: () {
                    if (GetPlatform.isDesktop || GetPlatform.isWeb) {
                      uploadImageWeb();
                      // imagePicker();
                    } else {
                      uploadImage();
                    }
                  },
                )
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
            alertDialogBox(context);
          },
          tooltip: "Delete Account ",
        )
      ],
    );
  }
}
