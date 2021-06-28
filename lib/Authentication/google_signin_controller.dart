import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_codes/Cloud_Firestore/cloud_firestore_service.dart';
import 'package:flutter_codes/Controller/app_controller.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSigninController extends GetxController {
  final AppController _app = Get.find();
  Future userSignIn() async {
    try {
      signInWithGoogle().then((userCredentials) async {
        _app.user.value = userCredentials.user;
        _app.isUserLogin.value = true;
        _app.profileMode.value = 1;
        _app.userid.value = userCredentials.user.uid;
        _app.username.value = userCredentials.user.displayName;
        _app.email.value = userCredentials.user.email;
        _app.photoUrl.value = userCredentials.user.photoURL;
        CloudFirestoreService()
            .addUser(docid: userCredentials.user.uid, type: 'Google Sign in');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isUserLogin', true);
        await prefs.setString('userid', _app.userid.value);
        await prefs.setString('photoURL', _app.photoUrl.value);
        await prefs.setString('displayName', _app.username.value);
        await prefs.setString('email', _app.email.value);
        await prefs.setInt('userProfileMode', _app.profileMode.value);
        print('Sign in as ${userCredentials.user.email}');
        _app.message(title: 'Success!', body: 'User logged in successfully.');
        Get.offAllNamed("/Home");
        return true;
      });
    } catch (e) {
      _app.message(
          title: 'Sign in Failed',
          body: 'Plaese check your internet connection and try again later.');
      printError(info: e.printError());
      return false;
    }
  }

// signin with google
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // for logging out
  Future userSignOut() async {
    try {
      FirebaseAuth.instance.signOut().then((value) async {
        GoogleSignIn().signOut();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        _app.isUserLogin.value = false;
        _app.profileMode.value = 0;
        _app.userid.value = '';
        _app.photoUrl.value = '';
        _app.username.value = '';
        _app.email.value = '';
        _app.user.value = null;
        _app.docid.value = '';
        await prefs.setBool('isUserLogin', false);
        print('Sign Out Successfully!');
        await prefs.clear();
        _app.message(title: 'Success', body: 'User Logged out!');
        Get.offAllNamed('/MainPage');
        return true;
      });
    } catch (e) {
      _app.message(
          title: 'Sign out Error',
          body: 'Plaese check your internet connection and try again later');
      printError(info: e.toString());
      return false;
    }
  }

  // for keeping user logged in in the application
  Future checkUserLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isUserLogin') == null)
      prefs.setBool('isUserLogin', false);
    _app.isUserLogin.value = (prefs.getBool('isUserLogin') ?? false);
    print('Login Cache: ${prefs.getBool('isUserLogin').toString()}');
    if (_app.isUserLogin.value) {
      _app.userid.value = prefs.getString('userid');
      _app.photoUrl.value = prefs.getString('photoURL');
      _app.username.value = prefs.getString('displayName');
      _app.email.value = prefs.getString('email');
      _app.profileMode.value = prefs.getInt('userProfileMode');
      return true;
    } else {
      return null;
    }
  }

  // for deleting using account if he/she  want too
  Future deleteAccount() async {
    try {
      await FirebaseAuth.instance.currentUser.delete().then((value) async {
        await GoogleSignIn().disconnect();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        _app.isUserLogin.value = false;
        _app.profileMode.value = 2;
        _app.userid.value = '';
        _app.photoUrl.value = '';
        _app.username.value = '';
        _app.email.value = '';
        _app.user.value = null;
        _app.docid.value = '';
        await prefs.setBool('isUserLogin', false);
        print('Sign Out Successfully!');
        await prefs.clear();
        _app.message(
            title: "Success!",
            body: "Your account has beed deleted successfully.");
        print('User Deleted');
        Get.offAllNamed('/MainPage');
        return true;
      });
    } catch (e) {
      _app.message(
          title: 'Account Deletion Error:',
          body: 'Plaese check your internet connection and try again later');
      print("User Deleted Exception:" + e.toString());
      return false;
    }
  }
}
