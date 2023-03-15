import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/neo_function/bgm.dart';
import 'package:neologism/neo_function/essay_func.dart';
import 'package:neologism/neo_function/quiz_func.dart';
import 'package:neologism/pages/quiz_page/word_quiz.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:neologism/datas/sentence_data.dart';
import 'package:neologism/widgets/Buttons.dart';
import 'package:neologism/widgets/appbar.dart';

final TextEditingController textcontroller = TextEditingController();
String entertext = "";
String wordhint = "";
bool typetext = true;
int answer_chance = 3;
int word_num = 0;
Timer? _essaytimer;
int essayTime = 15;
String _essayTime = "15";

setinit() {
  essayTime = 15;
  answer = false;
  order = makenumber(sen_data.length)[0];
  essay_answershow = false;
  idx = 1;
  answer_chance = 3;
  hint_num = 5;
  number_answer = 0;
  entertext = "";
  descblocked = true;
  hintclicked = false;
  hintblocked = false;
  typetext = true;
  wordhint = "";
  essay_running = true;
}

timeout() {
  essay_running = false;
  answer_chance = 0;
  essay_answershow = true;
  typetext = false;
  hintblocked = true;
}

class EssayQuiz extends StatefulWidget {
  const EssayQuiz({super.key});

  @override
  State<EssayQuiz> createState() => _EssayQuizState();
}

class _EssayQuizState extends State<EssayQuiz> {
  @override
  void initState() {
    super.initState();
    _essaytimer?.cancel();
    setinit();
    _essaytimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (essay_running) {
          essayTime--;
        }
        _essayTime = essayTime.toString();
        if (essayTime <= 0) {
          timeout();
        }
      });
    });
  }

  @override
  void dispose() {
    _essaytimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String ans = sen_data[order]["answer"].toString();
    List split_list = sen_data[order]["answer"].toString().split('');
    String split_hint = split_list[word_num];
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Get.find<BlackModeController>().blackmode == true
              ? blackmodecolor
              : notblackmodecolor,
          appBar: const QuizAppBar(
            apptitle: '문장 퀴즈',
            blackbutton: BlackModeButton(),
          ),
          resizeToAvoidBottomInset: false,
          body: WillPopScope(
            onWillPop: () => quizonWillPop(context),
            child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                padding: const EdgeInsets.fromLTRB(0.0, 30.0, 15.0, 0),
                child: Column(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "$idx/10",
                              style: TextStyle(
                                  color:
                                      Get.find<BlackModeController>().blackmode ==
                                              true
                                          ? Colors.white
                                          : Colors.black,
                                  fontSize: 20),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              "남은시간: $_essayTime" ,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: essayTime <= 3
                                      ? Colors.red
                                      : (Get.find<BlackModeController>()
                                                  .blackmode ==
                                              true
                                          ? Colors.white
                                          : Colors.black)),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: hintclicked == false &&
                                          hintblocked == false &&
                                          hint_num != 0
                                      ? () {
                                          showhint(context, sen_data);
                                          setState(() {
                                            hintclicked = true;
                                            hint_num--;
                                          });
                                        }
                                      : null,
                                  icon: Icon(Icons.lightbulb,
                                      color: hintclicked == false
                                          ? Colors.grey
                                          : Colors.yellow)),
                              Text("X$hint_num",
                                  style: TextStyle(
                                      color: Get.find<BlackModeController>()
                                                  .blackmode ==
                                              true
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 20))
                            ],
                          ),
                          Text("맞춘개수: $number_answer",
                              style: TextStyle(
                                  color:
                                      Get.find<BlackModeController>().blackmode ==
                                              true
                                          ? Colors.white
                                          : Colors.black,
                                  fontSize: 20))
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40.0, 30.0, 0.0, 0.0),
                    child: Text(
                      sen_data[order]["question"].toString(),
                      style: TextStyle(
                          color: Get.find<BlackModeController>().blackmode == true
                              ? Colors.white
                              : Colors.black,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < spellingnum(); i++)
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 0.0),
                          child: SizedBox(
                            width: 45,
                            height: 45,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 25,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  i == word_num ? wordhint : "",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'MapleStory'),
                                ),
                              ),
                            ),
                          ),
                        )
                    ],
                  )
                ]),
              ),
              const SizedBox(height: 10,),
              Divider(
                height: 30,
                color: Get.find<BlackModeController>().blackmode == true
                    ? Colors.white
                    : Colors.black,
              ),           
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                    enabled: typetext,
                    controller: textcontroller,
                    textCapitalization: TextCapitalization.characters,
                    onChanged: (newText) {
                      entertext = newText;
                    },
                    onSubmitted: (entertext) {
                      setState(() {
                        isanswer(entertext);
                        essay_answershow = true;
                        if (answer_chance == 0) {
                          typetext = false;
                          hintblocked = true;
                        } else if (answer_chance == 1) {
                          wordhint = split_hint;
                        }
                      });
                    },
                    style: TextStyle(
                        color: Get.find<BlackModeController>().blackmode == true
                            ? Colors.white
                            : Colors.black,
                        fontSize: 20),
                    decoration: InputDecoration(
                        hintText: "정답을 입력하세요.",
                        hintStyle:
                            TextStyle(fontSize: 20, color: Colors.grey[500]),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.greenAccent)),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        disabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)))),
              ),
              essay_answershow == true
                  ? answer == true
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: SizedBox(
                                width: 100,
                                height: 40,
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: Colors.blue[400],
                                        shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                                color: Colors.white, width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(15.0))),
                                    onPressed: () {
                                      setState(() {
                                        if (idx < 10) {
                                          essaynextpage();
                                          textcontroller.clear();
                                          typetext = true;
                                        } else {
                                          gameEndSound();
                                          endpage(context, '/sentence',
                                              'sentencequiz');
                                        }
                                      });
                                    },
                                    child: const Text(
                                      "다음",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.0),
                                    )),
                              ),
                            ),
                            Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text: "\"${sen_data[order]["answer"]}\"",
                                          style: const TextStyle(
                                              color: Colors.blue,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "MapleStory"),
                                        ),
                                        const TextSpan(text: "   "),
                                        TextSpan(
                                          text: "정답입니다!",
                                          style: TextStyle(
                                              color:
                                                  Get.find<BlackModeController>()
                                                              .blackmode ==
                                                          true
                                                      ? Colors.white
                                                      : Colors.black,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "MapleStory"),
                                        )
                                      ]),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.all(25),
                                  child: Text(sen_data[order]["desc"],
                                      style: TextStyle(
                                          color: Get.find<BlackModeController>()
                                                      .blackmode ==
                                                  true
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'MapleStory')),
                                ),
                              ],
                            )
                          ],
                        )
                      : answer_chance == 0
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: SizedBox(
                                    width: 100,
                                    height: 40,
                                    child: TextButton(
                                        style: TextButton.styleFrom(
                                            backgroundColor: Colors.blue[400],
                                            shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                    color: Colors.white,
                                                    width: 1.0),
                                                borderRadius:
                                                    BorderRadius.circular(15.0))),
                                        onPressed: () {
                                          setState(() {
                                            if (idx < 10) {
                                              essaynextpage();
                                              textcontroller.clear();
                                              typetext = true;
                                            } else {
                                              endpage(context, '/sentence',
                                                  'sentencequiz');
                                            }
                                          });
                                        },
                                        child: const Text(
                                          "다음",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0),
                                        )),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Column(
                                      children: [
                                        RichText(
                                            text: TextSpan(
                                                text: '정답은 ',
                                                style: TextStyle(
                                                    color:
                                                        Get.find<BlackModeController>()
                                                                    .blackmode ==
                                                                true
                                                            ? Colors.white
                                                            : Colors.black,
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'MapleStory'),
                                                children: <TextSpan>[
                                              TextSpan(
                                                  text: "\"" + ans + "\"",
                                                  style: const TextStyle(
                                                      color: Colors.blue,
                                                      fontFamily: 'MapleStory')),
                                              TextSpan(
                                                  text: " 였습니다.",
                                                  style: TextStyle(
                                                      color:
                                                          Get.find<BlackModeController>()
                                                                      .blackmode ==
                                                                  true
                                                              ? Colors.white
                                                              : Colors.black,
                                                      fontSize: 22,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'MapleStory'))
                                            ])),
                                        Padding(
                                          padding: const EdgeInsets.all(25),
                                          child: Text(sen_data[order]["desc"],
                                              style: TextStyle(
                                                  color:
                                                      Get.find<BlackModeController>()
                                                                  .blackmode ==
                                                              true
                                                          ? Colors.white
                                                          : Colors.black,
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'MapleStory')),
                                        ),
                                      ],
                                    ))
                              ],
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: RichText(
                                  text: TextSpan(
                                      text: '오답입니다! 기회가 ',
                                      style: TextStyle(
                                          color: Get.find<BlackModeController>()
                                                      .blackmode ==
                                                  true
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'MapleStory'),
                                      children: <TextSpan>[
                                    TextSpan(
                                        text: "$answer_chance",
                                        style: const TextStyle(
                                            color: Colors.blue,
                                            fontFamily: 'MapleStory')),
                                    TextSpan(
                                        text: "번 남았습니다!",
                                        style: TextStyle(
                                            color: Get.find<BlackModeController>()
                                                        .blackmode ==
                                                    true
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'MapleStory'))
                                  ])),
                            )
                  : const SizedBox()
            ]),
          ),
        ),
      ),
    );
  }
}
