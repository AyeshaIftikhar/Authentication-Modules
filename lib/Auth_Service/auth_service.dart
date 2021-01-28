import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './auth_controller.dart';

// object of controller authentication controller
final AuthController c = Get.find();

class AuthService {
  // sharedpreferences to keep user loggedin. It will stored locally in a device to keep user logged in until he/she logged out himself/herself.
  SharedPreferences prefs;
  // String uid;
  // signin function
  Future<User> googleSignIn() async {
    try {
      // trigger the authentication flow
      c.account = await c.googleSignIn.signIn();
      // obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await c.account.authentication;
      // create new credentials
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // returns user credentials after signing in
      UserCredential userCredential =
          await c.auth.signInWithCredential(credential);
      // assign the user credentials to firebase user
      c.user = userCredential.user;
      // uid = c.user.uid;
      // if user is anonymous then check idToken
      assert(!c.user.isAnonymous);
      assert(await c.user.getIdToken() != null);
    } catch (e) {
      print("Error: " + e.toString());
      c.message("Attention!", e.toString());
    }
    return c.user;
  }

// set the preferences to keep user loggedin until he logged out himself
  login() async {
    try {
      //get sharedPreferences instance
      prefs = await SharedPreferences.getInstance();
      // create a preferences string key which depends on user id.
      // prefs.setString('userId', uid);
      prefs.setBool('auth', true);
      c.authSignIn.value = true;
    } catch (e) {
      print("Err: " + e.toString());
      c.message("Attention!", e.toString());
    }
  }

  // when the system came into extistences this function will be called to check whether the user is already logged in or not.
  /* --- Just create a boolean variable to specify the conditons to be processed.
    This function will be used in the following sequence and you have to make your class a stateful widget.
    @override
      void initState() {
          as.checkAutoLogin().then((value) {
            print(value);
            if (value == 'null') {
              print(c.authSignIn.value);
              c.authSignIn.value = false;
            } else if (value != null) {
              c.authSignIn.value = true;
            } else {
              c.authSignIn.value = false;
            }
          });
        super.initState();
      }
  */
  Future checkAutoLogin() async {
    try {
      prefs = await SharedPreferences.getInstance();
      // get the value of "userId" and assigned it to a string variable userid.
      // String userid = prefs.getString('userId');
      // return the userid
      // return userid.toString();
      c.authSignIn.value = prefs.getBool('auth') ?? false;
      User appuser = c.auth.currentUser;
      return appuser;
    } catch (e) {
      print("Err: " + e.toString());
      c.message("Attention!", e.toString());
    }
  }

// this function will signed out a user from the system.
  Future<void> signOutGoogle() async {
    try {
      // you have to signed out the FirebaseAuth too.So auth.signOut() will do that.
      await c.auth.signOut();
      prefs = await SharedPreferences.getInstance();
      // clear the preferences from the device.
      // await prefs.remove('userId');
      await prefs.setBool('auth', false);
      // make your conditional variable to its default state
      c.authSignIn.value = false;
      // set the firebase user to null to clear its instances
      c.user = null;
      // uid = '';
      // signed out the google account authentication flow.
      await c.googleSignIn.signOut();
      print('user signed out');
    } catch (e) {
      print("Err:" + e.toString());
      c.message("Attention!", e.toString());
    }
  }

  // delete the user account from the system. But with deletion we will logged out the user as well.
  Future<void> deleteAccount() async {
    try {
      prefs = await SharedPreferences.getInstance();
      // clear the preferences from the device.
      // await prefs.remove('userId');
      await prefs.setBool('auth', false);
      // make your conditional variable to its default state
      c.authSignIn.value = false;
      // set the firebase user to null to clear its instances
      c.user = null;
      // uid = '';
      // auth signed out
      await c.auth.signOut();
      // google account signed out
      await c.googleSignIn.signOut();
      // delete the user from the system
      await c.user.delete();
      print("User Deleted");
    } catch (e) {
      print("Err:" + e.toString());
      c.message("Attention!", e.toString());
    }
  }
}
