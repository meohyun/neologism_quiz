import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';

class ProfileImageController extends GetxController {
  RxBool isProfilePath = false.obs;
  RxString profilePath = "".obs;
  RxList profilepaths = [].obs;
  RxList isprofilepaths = [].obs;

  void setProfileImagePath(String path) {
    profilePath.value = path;
    isProfilePath.value = true;
  }

  void pathput(String path) {
    profilepaths.add(path);
  }

  void hasimageput(bool hasimage) {
    isprofilepaths.add(hasimage);
  }
}
