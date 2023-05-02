import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/pages/startpage.dart';

void logout(context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return GetBuilder(
          init: BlackModeController(),
          builder: (_) => Dialog(
            shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 3,
                      color: Get.find<BlackModeController>().blackmode
                          ? Colors.white
                          : Colors.deepPurple.shade100),
                  borderRadius: const BorderRadius.all(Radius.circular(25))),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 200,
              decoration: BoxDecoration(
                  color: Get.find<BlackModeController>().blackmode == true
                      ? Colors.black
                      : Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(color: Colors.white, width: 1.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "로그아웃 하시겠습니까?",
                    style: TextStyle(
                        fontSize: 25.0,
                        color: Get.find<BlackModeController>().blackmode == true
                            ? Colors.white
                            : blackmodecolor),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "예",
                              style: TextStyle(fontSize: 25.0),
                            )),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "아니요",
                              style: TextStyle(fontSize: 25.0),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
}
