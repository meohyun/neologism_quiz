import 'dart:math';

import 'package:flutter/material.dart';
import 'package:neologism/neo_function/essay_func.dart';
import 'package:neologism/neo_function/quiz_func.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:neologism/datas/sentence_data.dart';
import 'package:neologism/widgets/Buttons.dart';
import 'package:neologism/widgets/appbar.dart';

final TextEditingController textcontroller = TextEditingController();
String entertext = "";
String wordhint = "";
bool typetext = true;
bool _wordhintblocked = true;
int answer_chance = 3;
int word_num = 0;

setinit() {
  answer = false;
  order = makenumber(sen_data.length)[0];
  answershow = false;
  idx = 1;
  answer_chance = 3;
  hint_num = 5;
  number_answer = 0;
  entertext = "";
  hintclicked = false;
  hintblocked = false;
  typetext = true;
  wordhint = "";
  _wordhintblocked = true;
}

class EssayQuiz extends StatefulWidget {
  EssayQuiz({super.key});

  @override
  State<EssayQuiz> createState() => _EssayQuizState();
}

class _EssayQuizState extends State<EssayQuiz> {
  @override
  void initState() {
    super.initState();
    setinit();
  }

  @override
  Widget build(BuildContext context) {
    String ans = sen_data[order]["answer"].toString();
    List split_list = sen_data[order]["answer"].toString().split('');

    String split_hint = split_list[word_num];
    return Scaffold(
        backgroundColor: blackmode == true ? blackmodecolor : notblackmodecolor,
        appBar: QuizAppBar(
          apptitle: '문장 퀴즈',
          blackbutton: BlackModeButton(
              ModeChanged: (value) => setState(() => blackmode = value)),
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            padding: EdgeInsets.fromLTRB(0.0, 30.0, 15.0, 80.0),
            child: Column(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      "$idx/10",
                      style: TextStyle(
                          color:
                              blackmode == true ? Colors.white : Colors.black,
                          fontSize: 20.0),
                      textAlign: TextAlign.start,
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
                                  color: blackmode == true
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 22.0))
                        ],
                      ),
                      Text("맞춘개수: " + "$number_answer",
                          style: TextStyle(
                              color: blackmode == true
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 20.0))
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40.0, 40.0, 0.0, 0.0),
                child: Text(
                  sen_data[order]["question"].toString(),
                  style: TextStyle(
                      color: blackmode == true ? Colors.white : Colors.black,
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < spellingnum(); i++)
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
                        child: SizedBox(
                          width: 50,
                          height: 50,
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
                                style: TextStyle(
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
                ),
              )
            ]),
          ),
          answer_chance == 1
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      if (_wordhintblocked == false) {
                        wordhint = split_hint;
                      }
                    });
                  },
                  child: Text(
                    "글자 힌트",
                    style: TextStyle(
                        color: blackmode == true ? Colors.white : Colors.black),
                  ))
              : SizedBox(),
          Divider(
            height: 40,
            color: blackmode == true ? Colors.white : Colors.black,
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
                    answershow = true;
                    if (answer_chance == 0) {
                      typetext = false;
                      hintblocked = true;
                    } else if (answer_chance == 1) {
                      _wordhintblocked = false;
                    }
                  });
                },
                style: TextStyle(
                    color: blackmode == true ? Colors.white : Colors.black),
                decoration: InputDecoration(
                    hintText: "정답을 입력하세요.",
                    hintStyle:
                        TextStyle(fontSize: 15.0, color: Colors.grey[500]),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)))),
          ),
          answershow == true
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
                                        side: BorderSide(
                                            color: Colors.white, width: 1.0),
                                        borderRadius:
                                            BorderRadius.circular(15.0))),
                                onPressed: () {
                                  setState(() {
                                    if (idx < 10) {
                                      nextpage();
                                      textcontroller.clear();
                                      typetext = true;
                                    } else {
                                      endpage(context, '/sentence');
                                    }
                                  });
                                },
                                child: Text(
                                  "다음",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Text(
                            "정답입니다!",
                            style: TextStyle(
                                color: blackmode == true
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
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
                                            side: BorderSide(
                                                color: Colors.white,
                                                width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(15.0))),
                                    onPressed: () {
                                      setState(() {
                                        if (idx < 10) {
                                          nextpage();
                                          textcontroller.clear();
                                          typetext = true;
                                        } else {
                                          endpage(context, '/sentence');
                                        }
                                      });
                                    },
                                    child: Text(
                                      "다음",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.0),
                                    )),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: RichText(
                                    text: TextSpan(
                                        text: '정답은 ',
                                        style: TextStyle(
                                            color: blackmode == true
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'MapleStory'),
                                        children: <TextSpan>[
                                      TextSpan(
                                          text: "\"$ans" + "\"",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontFamily: 'MapleStory')),
                                      TextSpan(
                                          text: " 였습니다.",
                                          style: TextStyle(
                                              color: blackmode == true
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'MapleStory'))
                                    ])))
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: RichText(
                              text: TextSpan(
                                  text: '오답입니다! 기회가 ',
                                  style: TextStyle(
                                      color: blackmode == true
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'MapleStory'),
                                  children: <TextSpan>[
                                TextSpan(
                                    text: "$answer_chance",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontFamily: 'MapleStory')),
                                TextSpan(
                                    text: "번 남았습니다!",
                                    style: TextStyle(
                                        color: blackmode == true
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'MapleStory'))
                              ])),
                        )
              : SizedBox()
        ]));
  }
}

Widget boxDecoration() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
    child: SizedBox(
      width: 50,
      height: 50,
      child: DecoratedBox(
        child: Center(
          child: Text(
            wordhint,
            style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: 'MapleStory'),
          ),
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 25,
          ),
        ),
      ),
    ),
  );
}
