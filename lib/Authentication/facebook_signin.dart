import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Cloud_Firestore/cloud_firestore_service.dart';
import '../Controller/app_controller.dart';

class FacebookLoginService {
  final AppController _app = Get.find();
  Future userFacebookLogin() async {
    try {
      signInWithFacebook().then((credentials) async {
        _app.user.value = credentials.user;
        _app.isUserLogin.value = true;
        _app.profileMode.value = 2;
        _app.userid.value = credentials.user.uid;
        _app.username.value = credentials.user.displayName;
        _app.email.value = credentials.user.email;
        _app.photoUrl.value = credentials.user.photoURL;
        CloudFirestoreService()
            .addUser(docid: credentials.user.uid, type: 'Facebook Login');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isUserLogin', true);
        await prefs.setString('userid', _app.userid.value);
        await prefs.setString('photoURL', _app.photoUrl.value);
        await prefs.setString('displayName', _app.username.value);
        await prefs.setString('email', _app.email.value);
        await prefs.setInt('userProfileMode', _app.profileMode.value);
        print('Sign in as ${credentials.user.email}');
        _app.message(title: 'Success!', body: 'User logged in successfully.');
        Get.offAllNamed("/Home");
        return true;
      });
    } catch (e) {
      print('Facebook Login Exception: $e');
      _app.message(
          title: 'Sign in Error:',
          body: 'Plaese check your internet connection and try again later');
      return null;
    }
  }

  Future<UserCredential> signInWithFacebook() async {
    try {
      if (GetPlatform.isAndroid) {
        // Trigger the sign-in flow
        var result = await FacebookAuth.instance.login();
        // Create a credential from the access token
        final facebookAuthCredential =
            FacebookAuthProvider.credential(result.accessToken.token);
        // Once signed in, return the UserCredentials
        return await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);
      } else if (GetPlatform.isWeb) {
        // Create a new provider
        FacebookAuthProvider facebookProvider = FacebookAuthProvider();
        facebookProvider.addScope('email');
        facebookProvider.setCustomParameters({
          'display': 'popup',
        });
        // Once signed in, return the UserCredential
        return await FirebaseAuth.instance.signInWithPopup(facebookProvider);
        // Or use signInWithRedirect
        // return await FirebaseAuth.instance.signInWithRedirect(facebookProvider);
      }
      return null;
    } catch (e) {
      print('Facebook Credentials Exception: $e');
      return null;
    }
  }

  Future loggoutFacebookUser() async {
    try {
      FirebaseAuth.instance.signOut().then((signOut) async {
        FacebookAuth.instance.logOut();
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
      print('Facebook User Logout Exception: $e');
       _app.message(
          title: 'Sign out Error:',
          body: 'Plaese check your internet connection and try again later');
    }
  }

  Future deleteFacebookUser() async {
    try {
      await FirebaseAuth.instance.currentUser.delete().then((value) async {
        // await FacebookAuth.instance.disconnect();
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
      print("Facebook User Deleted Exception:" + e.toString());
      return false;
    }
  }
}
