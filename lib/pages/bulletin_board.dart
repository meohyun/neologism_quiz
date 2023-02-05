import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/pages/startpage.dart';

class Bulletin_Board extends StatelessWidget {
  const Bulletin_Board({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => Scaffold(
        appBar: AppBar(
          backgroundColor: Get.find<BlackModeController>().blackmode
              ? blackmodecolor
              : notblackmodecolor,
          title: Text(
            "건의 게시판",
            style: TextStyle(
              color: Get.find<BlackModeController>().blackmode
                  ? Colors.white
                  : blackmodecolor,
            ),
          ),
          actions: [
            CircleAvatar(
              backgroundColor: Get.find<BlackModeController>().blackmode
                  ? blackmodecolor
                  : notblackmodecolor,
              child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.add,
                      color: Get.find<BlackModeController>().blackmode
                          ? Colors.white
                          : blackmodecolor)),
            ),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  color: Get.find<BlackModeController>().blackmode
                      ? Colors.white
                      : blackmodecolor,
                ))
          ],
        ),
        body: Container(
            color: Get.find<BlackModeController>().blackmode
                ? blackmodecolor
                : notblackmodecolor,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Text(
                "건의 게시판 입니다.",
                style: TextStyle(
                  color: Get.find<BlackModeController>().blackmode
                      ? Colors.white
                      : blackmodecolor,
                ),
              ),
            )),
      ),
    );
  }
}
