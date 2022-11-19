import 'package:flutter/material.dart';
import 'package:neologism/neo_function/quiz_func.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:neologism/sentence_data.dart';

final TextEditingController textcontroller = TextEditingController();
String entertext = "";
bool typetext = true;
int answer_chance = 3;

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
    return Scaffold(
        backgroundColor: blackmode == true ? blackmodecolor : notblackmodecolor,
        appBar: AppBar(
          backgroundColor:
              blackmode == true ? blackmodecolor : notblackmodecolor,
          centerTitle: false,
          title: Text("문장 퀴즈"),
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              color: blackmode == true ? Colors.white : blackmodecolor,
            ),
            onTap: () {
              quizexit(context);
            },
          ),
          actions: [
            BlackModeButton(
              ModeChanged: (value) => setState(() => blackmode = value),
            )
          ],
          elevation: 2.0,
          shadowColor: blackmode == true ? Colors.white : blackmodecolor,
          titleTextStyle: TextTheme(
                  headline6: TextStyle(
                      color: blackmode == true ? Colors.white : blackmodecolor,
                      fontSize: 20.0))
              .headline6,
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
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < spellingnum(); i++) ...[boxDecoration()]
                  ],
                ),
              )
            ]),
          ),
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
                  });
                },
                style: TextStyle(
                    color: blackmode == true ? Colors.white : Colors.black),
                decoration: InputDecoration(
                    hintText: "정답을 입력하세요.",
                    hintStyle:
                        TextStyle(fontSize: 15.0, color: Colors.grey[500]),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
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
                      ? Padding(
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
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            "오답입니다! 기회가 $answer_chance번 남았습니다!",
                            style: TextStyle(
                                color: blackmode == true
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                        )
              : SizedBox()
        ]));
  }
}

isanswer(value) {
  if (value.toString().toUpperCase() == sen_data[order]["answer"].toString()) {
    answer = true;
    number_answer++;
    hintblocked = true;
    typetext = false;
  } else {
    answer_chance--;
  }
}

spellingnum() {
  List list = sen_data[order]["answer"].toString().split('');
  int nums = list.length;

  return nums;
}

Widget boxDecoration() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
    child: DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 20,
        ),
      ),
    ),
  );
}

//next button
class NextButton extends StatefulWidget {
  NextButton({super.key, required this.PageChanged});

  final ValueChanged<Function> PageChanged;

  @override
  State<NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: SizedBox(
        width: 100,
        height: 40,
        child: TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.blue[400],
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white, width: 1.0),
                    borderRadius: BorderRadius.circular(15.0))),
            onPressed: () {
              widget.PageChanged(nextpage());
              setState(() {
                if (idx < 10) {
                  nextpage();
                } else {
                  endpage(context, '/sentence');
                }
              });
            },
            child: Text(
              "다음",
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            )),
      ),
    );
  }
}
