import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';

class chatcontroller extends GetxController {
  RxBool chatmodified = false.obs;

  RxBool get _chatmodified => chatmodified;

  void chatmodify() {
    if (chatmodified.isTrue) {
      chatmodified.value = false;
    } else {
      chatmodified.value = true;
    }
  }
}
