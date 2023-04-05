import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:neologism/getx/blackmode.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key, this.user, this.imageurl});

  final user;
  final imageurl;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            "$user님의 사진",
            style: TextStyle(
              color: Get.find<BlackModeController>().blackmode
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          backgroundColor: Get.find<BlackModeController>().blackmode
              ? Colors.black
              : Colors.deepPurple[100],
        ),
        body: Container(
          color: Get.find<BlackModeController>().blackmode
              ? Colors.black
              : Colors.deepPurple[100],
          child: Center(
            child: Image.network(imageurl),
          ),
        ),
      ),
    );
  }
}
