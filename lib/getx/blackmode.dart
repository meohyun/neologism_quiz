import 'package:get/get_state_manager/get_state_manager.dart';

class BlackModeController extends GetxController {
  bool _blackmode = false;
  bool get blackmode => _blackmode;

  void blackmodechange() {
    _blackmode = !_blackmode;
    update();
  }
}
