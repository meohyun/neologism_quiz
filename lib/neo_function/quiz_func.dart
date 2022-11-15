import 'dart:math';

import 'package:flutter/material.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:neologism/quizdata.dart';

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

showanswer() {
  answershow = true;
  hintblocked = true;
}

nextpage() {
  answershow = false;
  order = makenumber(80)[idx - 1];
  hintclicked = false;
  hintblocked = false;
  idx++;
}

endpage(context) {
  showDialog(
      useRootNavigator: false,
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 300,
            decoration: BoxDecoration(
                color: blackmode == true ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                    color: Colors.white, style: BorderStyle.solid, width: 1.0)),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$number_answer개 맞추셨습니다.",
                    style: TextStyle(
                        fontSize: 25.0,
                        color: blackmode == true ? Colors.white : Colors.black),
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
                            setinit();
                            Navigator.pushNamed(context, '/word');
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
        );
      });
}

quizexit(context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 300,
            decoration: BoxDecoration(
                color: blackmode == true ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                    color: Colors.white, style: BorderStyle.solid, width: 1.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    "게임에서 나가시겠습니까?",
                    style: TextStyle(
                        fontSize: 28.0,
                        color: blackmode == true ? Colors.white : Colors.black),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        style:
                            TextButton.styleFrom(backgroundColor: Colors.blue),
                        onPressed: () {
                          Navigator.pushNamed(context, '/');
                        },
                        child: Text(
                          "나가기",
                          style: TextStyle(color: Colors.white),
                        )),
                    SizedBox(
                      width: 30,
                    ),
                    TextButton(
                        style:
                            TextButton.styleFrom(backgroundColor: Colors.blue),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child:
                            Text("취소", style: TextStyle(color: Colors.white))),
                  ],
                ),
              ],
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
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 300,
            decoration: BoxDecoration(
                color: blackmode == true ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(color: Colors.white, width: 1.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Hint",
                  style: TextStyle(
                      fontSize: 25.0,
                      color: blackmode == true ? Colors.white : blackmodecolor),
                ),
                Text(
                  data[order]["hint"],
                  style: TextStyle(
                      fontSize: 20.0,
                      color: blackmode == true ? Colors.white : blackmodecolor),
                ),
              ],
            ),
          ),
        );
      });
}
