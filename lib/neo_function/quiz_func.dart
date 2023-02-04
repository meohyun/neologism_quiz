import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/pages/essay_quiz.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:neologism/datas/quizdata.dart';
import 'package:neologism/pages/word_quiz.dart';
import 'package:neologism/widgets/Buttons.dart';

Timer? _timer;
int order = 0;
int idx = 1;
int number_answer = 0;
int hint_num = 5;
bool answer = false;
bool correct = false;
bool answershow = false;
bool buttonclicked = false;
bool hintclicked = false;
bool hintblocked = false;
bool is_running = true;
bool essay_running = true;

nextpage() {
  answer = false;
  answershow = false;
  order = makenumber(datas.length)[idx - 1];
  hintclicked = false;
  hintblocked = false;
  idx++;
  textcontroller.clear();
  typetext = true;
  answer_chance = 3;
  wordhint = "";
  descblocked = false;
  time = 10;
  essayTime = 15;
  is_running = true;
  essay_running = true;
}

endpage(context, page) {
  showDialog(
      useRootNavigator: false,
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return GetBuilder(
          init: BlackModeController(),
          builder: (_) => Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 300,
              decoration: BoxDecoration(
                  color: Get.find<BlackModeController>().blackmode == true
                      ? Colors.black
                      : notblackmodecolor,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                      color: Colors.white,
                      style: BorderStyle.solid,
                      width: 1.0)),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$number_answer개 맞추셨습니다.",
                      style: TextStyle(
                          fontSize: 25.0,
                          color:
                              Get.find<BlackModeController>().blackmode == true
                                  ? Colors.white
                                  : Colors.black),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.blue),
                            onPressed: () {
                              Navigator.pushNamed(context, '/');
                              textcontroller.text = "";
                              _timer?.cancel();
                            },
                            child: Text("홈으로",
                                style: TextStyle(color: Colors.white))),
                        SizedBox(
                          width: 50,
                        ),
                        TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.blue),
                            onPressed: () {
                              Navigator.pushNamed(context, page);
                              textcontroller.text = "";
                            },
                            child: Text(
                              "다시하기",
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      });
}

quizexit(context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return GetBuilder(
          init: BlackModeController(),
          builder: (_) => Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 300,
              decoration: BoxDecoration(
                  color: Get.find<BlackModeController>().blackmode == true
                      ? Colors.black
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                      color: Colors.white,
                      style: BorderStyle.solid,
                      width: 1.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      "게임에서 나가시겠습니까?",
                      style: TextStyle(
                          fontSize: 28.0,
                          color:
                              Get.find<BlackModeController>().blackmode == true
                                  ? Colors.white
                                  : Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.blue),
                          onPressed: () {
                            Navigator.pushNamed(context, '/');
                            textcontroller.text = "";
                            _timer?.cancel();
                            is_running = false;
                            descblocked = true;
                          },
                          child: Text(
                            "나가기",
                            style: TextStyle(color: Colors.white),
                          )),
                      SizedBox(
                        width: 30,
                      ),
                      TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.blue),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("취소",
                              style: TextStyle(color: Colors.white))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

makenumber(int num) {
  List<int> numberList = [];
  Random random = new Random();
  while (numberList.length < 10) {
    int random_number = random.nextInt(num);
    if (!numberList.contains(random_number)) {
      numberList.add(random_number);
    }
  }
  return numberList;
}

showhint(context, data) {
  showDialog(
      context: context,
      builder: (context) {
        return GetBuilder(
          init: BlackModeController(),
          builder: (_) => Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
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
                    "Hint",
                    style: TextStyle(
                        fontSize: 25.0,
                        color: Get.find<BlackModeController>().blackmode == true
                            ? Colors.white
                            : blackmodecolor),
                  ),
                  Text(
                    data[order]["hint"],
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Get.find<BlackModeController>().blackmode == true
                            ? Colors.white
                            : blackmodecolor),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

// mainpage quiz choice
quiz_choice(context) {
  showDialog(
      useRootNavigator: false,
      context: context,
      builder: (context) {
        return GetBuilder(
          init: BlackModeController(),
          builder: (_) => Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 300,
              decoration: BoxDecoration(
                  color: Get.find<BlackModeController>().blackmode == true
                      ? Colors.black
                      : Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(color: Colors.white, width: 1.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "퀴즈를 선택해주세요!",
                    style: TextStyle(
                        color: Get.find<BlackModeController>().blackmode == true
                            ? Colors.white
                            : Colors.black,
                        fontSize: 25.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const MainPageButton(
                          page: '/word',
                          text: "단어 퀴즈",
                        ),
                        const MainPageButton(
                          page: '/sentence',
                          text: "문장 퀴즈",
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

showdesc(context) {
  showDialog(
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
                    datas[order]["desc_title"],
                    style: TextStyle(
                        fontSize: 25.0,
                        color: Get.find<BlackModeController>().blackmode == true
                            ? Colors.white
                            : blackmodecolor),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      datas[order]["desc"],
                      style: TextStyle(
                          fontSize: 20.0,
                          color:
                              Get.find<BlackModeController>().blackmode == true
                                  ? Colors.white
                                  : blackmodecolor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
