import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/pages/quiz_page/essay_quiz.dart';
import 'package:neologism/pages/quiz_page/word_quiz.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:neologism/datas/quizdata.dart';
import 'package:neologism/widgets/Buttons.dart';

Timer? _timer;
int order = 0;
int idx = 1;
int number_answer = 0;
int hint_num = 5;
bool answer = false;
bool correct = false;
bool answershow = false;
bool essay_answershow = false;
bool buttonclicked = false;
bool hintclicked = false;
bool hintblocked = false;
bool is_running = true;
bool essay_running = true;

nextpage() {
  answer = false;
  answershow = false;
  order = word_orders[idx];
  hintclicked = false;
  hintblocked = false;
  idx++;
  descblocked = false;
  time = 10;
  is_running = true;
}

Future<bool> onWillPop(context) async {
  return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("종료 하시겠습니까?"),
          actions: [
            TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text("예", style: TextStyle(fontSize: 18))),
            TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text("아니오", style: TextStyle(fontSize: 18)))
          ],
        );
      });
}

Future<bool> quizonWillPop(context) async {
  return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("퀴즈를 종료 하시겠습니까?"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
                child: const Text("예", style: TextStyle(fontSize: 18))),
            TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text("아니오", style: TextStyle(fontSize: 18)))
          ],
        );
      });
}

quizresult(String quiztype) {
  final user = FirebaseAuth.instance.currentUser!;
  final userid = user.uid;

  List result = [
    {"result": number_answer, "type": quiztype, "time": Timestamp.now()}
  ];
  FirebaseFirestore.instance
      .collection('user')
      .doc('userdatabase')
      .update({'$userid.result': FieldValue.arrayUnion(result)});
}

endpage(context, page, String quiztype) {
  quizresult(quiztype);
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
                    const SizedBox(
                      height: 30,
                    ),
                    number_answer < 5
                        ? Text("아직 신조어 공부가 좀 더 필요해요.",
                            style: TextStyle(
                                fontSize: 18.0,
                                color:
                                    Get.find<BlackModeController>().blackmode ==
                                            true
                                        ? Colors.white
                                        : Colors.black))
                        : number_answer == 10
                            ? Text("당신은 신조어 박사입니다!",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: Get.find<BlackModeController>()
                                                .blackmode ==
                                            true
                                        ? Colors.white
                                        : Colors.black))
                            : Text("신조어 잘알이시네요!",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: Get.find<BlackModeController>()
                                                .blackmode ==
                                            true
                                        ? Colors.white
                                        : Colors.black)),
                    const SizedBox(
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
                            child: const Text("홈으로",
                                style: TextStyle(color: Colors.white))),
                        const SizedBox(
                          width: 50,
                        ),
                        TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.blue),
                            onPressed: () {
                              Navigator.pushNamed(context, page);
                              textcontroller.text = "";
                            },
                            child: const Text(
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

makenumber(int num) {
  List<int> numberList = [];
  Random random = Random();
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
                        MainPageButton(
                          page: NeologismQuiz(),
                          text: "단어 퀴즈",
                        ),
                        MainPageButton(
                          page: const EssayQuiz(),
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

showdesc(context, bool answer) {
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
                  answer == true
                      ? Text("정답입니다!",
                          style: TextStyle(
                            fontSize: 25.0,
                            color: Get.find<BlackModeController>().blackmode ==
                                    true
                                ? Colors.white
                                : blackmodecolor,
                          ))
                      : Text(
                          "오답입니다!",
                          style: TextStyle(
                              fontSize: 25.0,
                              color:
                                  Get.find<BlackModeController>().blackmode ==
                                          true
                                      ? Colors.white
                                      : blackmodecolor),
                        ),
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
