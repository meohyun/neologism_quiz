import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/neo_function/bgm.dart';
import 'package:neologism/neo_function/quiz_func.dart';
import 'package:neologism/pages/quiz_page/essay_quiz.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:neologism/datas/quizdata.dart';
import 'package:neologism/widgets/appbar.dart';
import 'package:neologism/widgets/Buttons.dart';

Timer? _timer;
bool descblocked = false;
int time = 10;
List<int> word_orders = [];
String _time = "10";

setinit() {
  time = 10;
  answer = false;
  word_orders = makenumber(datas.length);
  order = word_orders[0];
  answershow = false;
  idx = 1;
  hint_num = 5;
  number_answer = 0;
  hintclicked = false;
  hintblocked = false;
  descblocked = false;
  is_running = true;
}

class NeologismQuiz extends StatefulWidget {
  const NeologismQuiz({super.key});

  @override
  State<NeologismQuiz> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<NeologismQuiz> {
  showanswer(bool answer) {
    is_running = false;
    answershow = true;
    hintblocked = true;
    setState(() {
      if (descblocked == false) {
        showdesc(context, answer);
      }
      descblocked = true;
    });
  }

  @override
  void initState() {
    setinit();
    // timer
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (is_running) {
          time--;
        }
        _time = time.toString();
        if (time <= 0) {   
          showanswer(answer);
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => Scaffold(
        backgroundColor: Get.find<BlackModeController>().blackmode == true
            ? blackmodecolor
            : notblackmodecolor,
        appBar: const QuizAppBar(apptitle: '단어 퀴즈', blackbutton: BlackModeButton()),
        body: WillPopScope(
          onWillPop: () => quizonWillPop(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                padding: const EdgeInsets.fromLTRB(0.0, 20.0, 15.0, 0),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text(
                                "$idx/10",
                                style: TextStyle(
                                    color: Get.find<BlackModeController>()
                                                .blackmode ==
                                            true
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 18),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Text(
                              "남은시간: $_time",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: time <= 3
                                      ? Colors.red
                                      : (Get.find<BlackModeController>()
                                                  .blackmode ==
                                              true
                                          ? Colors.white
                                          : Colors.black)),
                            )
                          ],
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
                                            showhint(context, datas);
                                            setState(() {
                                              hint_num--;
                                              hintclicked = true;
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
                                        fontSize: 18))
                              ],
                            ),
                            Text("맞춘개수: $number_answer",
                                style: TextStyle(
                                    color: Get.find<BlackModeController>()
                                                .blackmode ==
                                            true
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 18))
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40.0, 40.0, 0.0, 0.0),
                      child: Text(
                        datas[order]["name"].toString(),
                        style: TextStyle(
                            color:
                                Get.find<BlackModeController>().blackmode == true
                                    ? Colors.white
                                    : Colors.black,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 20,
                color: Get.find<BlackModeController>().blackmode == true
                    ? Colors.white
                    : Colors.black,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.43,
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: 70,
                        child: Card(
                          color: Get.find<BlackModeController>().blackmode == true
                              ? blackmodecolor
                              : notblackmodecolor,
                          elevation: 0.0,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: answershow == true
                                        ? datas[order]["options"][index] ==
                                                datas[order]["answer"]
                                            ? Colors.greenAccent
                                            : Colors.red
                                        : Colors.white,
                                    width: answershow ? 2.5 : 1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              tileColor:
                                  Get.find<BlackModeController>().blackmode == true
                                      ? blackmodecolor
                                      : Colors.blue[300],
                              leading: Text(
                                (index + 1).toString(),
                                style: TextStyle(
                                    fontSize: 20,
                                    color:
                                        Get.find<BlackModeController>().blackmode ==
                                                true
                                            ? Colors.white
                                            : blackmodecolor),
                              ),
                              trailing: answershow == true
                                  ? datas[order]["options"][index] ==
                                          datas[order]["answer"]
                                      ? Icon(
                                          Icons.circle,
                                          color: Colors.greenAccent[400],
                                        )
                                      : const Icon(
                                          Icons.dangerous,
                                          color: Colors.red,
                                        )
                                  : null,
                              title: Text(
                                datas[order]["options"][index].toString(),
                                style: TextStyle(
                                    color:
                                        Get.find<BlackModeController>().blackmode ==
                                                true
                                            ? Colors.white
                                            : blackmodecolor,
                                    fontSize: 20),
                              ),
                              onTap: () {
                                if (datas[order]["options"][index] ==
                                    datas[order]["answer"]) {
                                  answer = true;
                                }
                                if (datas[order]["options"][index] ==
                                        datas[order]["answer"] &&
                                    answershow == false) {
                                  rightSound();
                                  number_answer++;
                                } else if (datas[order]["options"][index] !=
                                        datas[order]["answer"] &&
                                    answershow == false) {
                                  wrongSound();
                                }
                                showanswer(answer);
                              },
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              answershow == true
                  ? SizedBox(
                    height: 40,
                    width: 100,
                    child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.blue[400],
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.white, width: 1.0),
                                borderRadius: BorderRadius.circular(15.0))),
                        onPressed: () {
                          if (idx < 10) {
                            setState(() {
                              nextpage();
                            });
                          } else {
                            gameEndSound();
                            endpage(context, '/word', "wordquiz");
                          }
                        },
                        child: const Text(
                          "다음",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                  )
                  : const SizedBox(
                    height: 30,
                  )
            ],
          ),
        ),
      ),
    );
  }
}