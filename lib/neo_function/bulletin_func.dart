import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/pages/startpage.dart';

void deleteDialog(context, delete) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return GetBuilder(
          init: BlackModeController(),
          builder: (_) => Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 300,
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
                    "게시물을 삭제하시겠습니까?",
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
                              delete();
                              Navigator.pushNamed(context, '/bulletin');
                            },
                            child: Text(
                              "예",
                              style: TextStyle(fontSize: 25.0),
                            )),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
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

deleteChatDialog(context, delete, docs) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return GetBuilder(
          init: BlackModeController(),
          builder: (_) => Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
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
                    "댓글을 삭제하시겠습니까?",
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
                            delete(docs);
                            Navigator.pop(context);
                          },
                          child: Text(
                            "예",
                            style: TextStyle(fontSize: 25.0),
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "아니요",
                            style: TextStyle(fontSize: 25.0),
                          ))
                    ],
                  ))
                ],
              ),
            ),
          ),
        );
      });
}
