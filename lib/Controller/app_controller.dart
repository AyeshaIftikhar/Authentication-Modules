import 'package:auth_demo/Auth_Service/auth_controller.dart';
import 'package:get/get.dart';

final AuthController ac = Get.find();

class AppController extends GetxController {
  var userid = ac.user.uid;
  var img = ac.user.photoURL;
  var name = ac.user.displayName;
  var email = ac.user.email;

  var fsImgUrl = ''.obs;
}
