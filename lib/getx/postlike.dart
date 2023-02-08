import 'package:get/state_manager.dart';

class PostLikeController extends GetxController {
  RxBool likeclicked = false.obs;
  RxBool get _likeclicked => likeclicked;
  RxBool dislikeclicked = false.obs;
  RxBool get _dislikeclicked => dislikeclicked;

  void like() {
    if (likeclicked.isTrue) {
      likeclicked.value = false;
    } else {
      likeclicked.value = true;
    }
  }

  void dislike() {
    if (dislikeclicked.isTrue) {
      dislikeclicked.value = false;
    } else {
      dislikeclicked.value = true;
    }
  }
}
