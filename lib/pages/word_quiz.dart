import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/getx/nextpage.dart';
import 'package:neologism/neo_function/quiz_func.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:neologism/datas/quizdata.dart';
import 'package:neologism/widgets/appbar.dart';
import 'package:neologism/widgets/Buttons.dart';

bool descblocked = false;

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
          body: GetBuilder(
            init: NextPageController(),
            builder: (_) => Column(
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
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                              "${Get.find<NextPageController>().idx}/10",
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: Get.find<NextPageController>()
                                                      .hintclicked ==
                                                  false &&
                                              Get.find<NextPageController>()
                                                      .hintblocked ==
                                                  false &&
                                              Get.find<NextPageController>()
                                                      .hint_num !=
                                                  0
                                          ? () {
                                              showhint(context, datas);
                                              Get.find<NextPageController>()
                                                  .clickhint();
                                            }
                                          : null,
                                      icon: Icon(Icons.lightbulb,
                                          color: Get.find<NextPageController>()
                                                      .hintclicked ==
                                                  false
                                              ? Colors.grey
                                              : Colors.yellow)),
                                  Text(
                                      "X${Get.find<NextPageController>().hint_num}",
                                      style: TextStyle(
                                          color: Get.find<BlackModeController>()
                                                      .blackmode ==
                                                  true
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 22.0))
                                ],
                              ),
                              Text(
                                  "맞춘개수: " +
                                      "${Get.find<NextPageController>().number_answer}",
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
                        padding:
                            const EdgeInsets.fromLTRB(40.0, 40.0, 0.0, 0.0),
                        child: Text(
                          datas[Get.find<NextPageController>().order]["name"]
                              .toString(),
                          style: TextStyle(
                              color:
                                  Get.find<BlackModeController>().blackmode ==
                                          true
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
                          color:
                              Get.find<BlackModeController>().blackmode == true
                                  ? blackmodecolor
                                  : notblackmodecolor,
                          elevation: 0.0,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 14.0),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Get.find<BlackModeController>()
                                                .blackmode ==
                                            true
                                        ? Colors.white
                                        : Colors.teal),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              tileColor:
                                  Get.find<BlackModeController>().blackmode ==
                                          true
                                      ? blackmodecolor
                                      : Colors.blue[300],
                              leading: Text(
                                (index + 1).toString() + ".",
                                style: TextStyle(
                                    color: Get.find<BlackModeController>()
                                                .blackmode ==
                                            true
                                        ? Colors.white
                                        : blackmodecolor),
                              ),
                              trailing: Get.find<NextPageController>()
                                          .answershow ==
                                      true
                                  ? datas[Get.find<NextPageController>().order]
                                              ["options"][index] ==
                                          datas[Get.find<NextPageController>()
                                              .order]["answer"]
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
                                datas[Get.find<NextPageController>().order]
                                        ["options"][index]
                                    .toString(),
                                style: TextStyle(
                                    color: Get.find<BlackModeController>()
                                                .blackmode ==
                                            true
                                        ? Colors.white
                                        : blackmodecolor,
                                    fontSize: 18),
                              ),
                              onTap: () {
                                if (datas[Get.find<NextPageController>().order]
                                            ["options"][index] ==
                                        datas[Get.find<NextPageController>()
                                            .order]["answer"] &&
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
                answershow == true ? NextButton(page: '/word') : SizedBox()
              ],
            ),
          )),
    );
  }
}
