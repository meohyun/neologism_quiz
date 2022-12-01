import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/neo_function/quiz_func.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:neologism/datas/sentence_data.dart';
import 'package:neologism/widgets/Buttons.dart';
import 'package:neologism/widgets/appbar.dart';

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

class SentenceGame extends StatefulWidget {
  const SentenceGame({super.key});

  @override
  State<SentenceGame> createState() => _SentenceGameState();
}

class _SentenceGameState extends State<SentenceGame> {
  @override
  void initState() {
    super.initState();
    setinit();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => Scaffold(
          backgroundColor: Get.find<BlackModeController>().blackmode == true
              ? blackmodecolor
              : notblackmodecolor,
          appBar: QuizAppBar(apptitle: '문장 퀴즈', blackbutton: BlackModeButton()),
          body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              padding: EdgeInsets.fromLTRB(0.0, 20.0, 15.0, 50.0),
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
                                  Get.find<BlackModeController>().blackmode ==
                                          true
                                      ? Colors.white
                                      : Colors.black,
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
                      sen_data[order]["question"].toString(),
                      style: TextStyle(
                          color:
                              Get.find<BlackModeController>().blackmode == true
                                  ? Colors.white
                                  : Colors.black,
                          fontSize: 25.0),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 40,
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
                        padding: const EdgeInsets.only(top: 13.0),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color:
                                    Get.find<BlackModeController>().blackmode ==
                                            true
                                        ? Colors.white
                                        : Colors.teal),
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
                              ? sen_data[order]["options"][index] ==
                                      sen_data[order]["answer"]
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
                            sen_data[order]["options"][index].toString(),
                            style: TextStyle(
                                color:
                                    Get.find<BlackModeController>().blackmode ==
                                            true
                                        ? Colors.white
                                        : blackmodecolor),
                          ),
                          onTap: () {
                            if (sen_data[order]["options"][index] ==
                                    sen_data[order]["answer"] &&
                                answershow == false) {
                              number_answer++;
                            }
                            setState(() {
                              showanswer();
                            });
                          },
                        ),
                      ),
                    );
                  }),
            ),
            answershow == true
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.blue[400],
                            shape: RoundedRectangleBorder(
                                side:
                                    BorderSide(color: Colors.white, width: 1.0),
                                borderRadius: BorderRadius.circular(15.0))),
                        onPressed: () {
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
                          style: TextStyle(color: Colors.white),
                        )),
                  )
                : SizedBox()
          ])),
    );
  }
}
