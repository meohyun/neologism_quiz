import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';

class ProfileImageController extends GetxController {
  RxBool isProfilePath = false.obs;
  RxString profilePath = "".obs;

  void setProfileImagePath(String path) {
    profilePath.value = path;
    isProfilePath.value = true;
  }
}
