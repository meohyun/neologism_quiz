import 'package:flutter/material.dart';
import 'package:neologism/neo_function/quiz_func.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:neologism/quizdata.dart';
import 'package:neologism/sentence_data.dart';

final TextEditingController textcontroller = TextEditingController();
String entertext = "";

setinit() {
  answer = false;
  order = makenumber(sen_data.length)[0];
  answershow = false;
  idx = 1;
  hint_num = 5;
  number_answer = 0;
  hintclicked = false;
  hintblocked = false;
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
            child: Column(
              children: [
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
                        fontSize: 25.0),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 40,
            color: blackmode == true ? Colors.white : Colors.black,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
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
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey))),
            ),
          ),
          answershow == true
              ? answer == true
                  ? Column(
                      children: [
                        Text(
                          "정답입니다!",
                          style: TextStyle(
                              color: blackmode == true
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
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
                                  } else {
                                    endpage(context, '/sentence');
                                  }
                                });
                              },
                              child: Text(
                                "다음",
                                style: TextStyle(color: Colors.white),
                              )),
                        )
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        "오답입니다!",
                        style: TextStyle(
                            color: blackmode == true
                                ? Colors.white
                                : Colors.black),
                      ),
                    )
              : SizedBox()
        ]));
  }
}

isanswer(value) {
  if (value == sen_data[order]["answer"].toString()) {
    answer = true;
    number_answer++;
    hintblocked = true;
  }
}
