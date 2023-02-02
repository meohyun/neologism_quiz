import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/neo_function/quiz_func.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:neologism/datas/quizdata.dart';
import 'package:neologism/widgets/appbar.dart';
import 'package:neologism/widgets/Buttons.dart';

Timer? _timer;
bool descblocked = false;
int time = 15;
String a = "";

setinit() {
  answer = false;
  order = makenumber(datas.length)[0];
  answershow = false;
  idx = 1;
  hint_num = 5;
  number_answer = 0;
  hintclicked = false;
  hintblocked = false;
  descblocked = false;
  time = 10;
}

class NeologismQuiz extends StatefulWidget {
  @override
  State<NeologismQuiz> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<NeologismQuiz> {
  @override
  void initState() {
    super.initState();
    setinit();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        a = time.toString();
        time--;
        if (time < 1) {
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => Scaffold(
        backgroundColor: Get.find<BlackModeController>().blackmode == true
            ? blackmodecolor
            : notblackmodecolor,
        appBar: QuizAppBar(apptitle: '단어 퀴즈', blackbutton: BlackModeButton()),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              padding: EdgeInsets.fromLTRB(0.0, 20.0, 15.0, 80.0),
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
                                  fontSize: 20.0),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Text(
                            "남은시간: " + a,
                            style: TextStyle(fontSize: 20),
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
                                      fontSize: 22.0))
                            ],
                          ),
                          Text("맞춘개수: " + "$number_answer",
                              style: TextStyle(
                                  color: Get.find<BlackModeController>()
                                              .blackmode ==
                                          true
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
            Expanded(
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Get.find<BlackModeController>().blackmode == true
                          ? blackmodecolor
                          : notblackmodecolor,
                      elevation: 0.0,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 14.0),
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
                            (index + 1).toString() + ".",
                            style: TextStyle(
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
                                  : Icon(
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
                                fontSize: 18),
                          ),
                          onTap: () {
                            if (datas[order]["options"][index] ==
                                    datas[order]["answer"] &&
                                answershow == false) {
                              number_answer++;
                            }
                            setState(() {
                              showanswer();
                              if (descblocked == false) {
                                showdesc(context);
                              }
                              descblocked = true;
                            });
                          },
                        ),
                      ),
                    );
                  }),
            ),
            answershow == true
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: SizedBox(
                      width: 100,
                      child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.blue[400],
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.white, width: 1.0),
                                  borderRadius: BorderRadius.circular(15.0))),
                          onPressed: () {
                            if (idx < 10) {
                              setState(() {
                                nextpage();
                              });
                            } else {
                              endpage(context, '/word');
                            }
                          },
                          child: Text(
                            "다음",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                    ))
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
