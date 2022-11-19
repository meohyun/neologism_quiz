import 'package:flutter/material.dart';
import 'package:neologism/neo_function/quiz_func.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:neologism/quizdata.dart';
import 'package:neologism/widgets/next_button.dart';

setinit() {
  answer = false;
  order = makenumber(datas.length)[0];
  answershow = false;
  idx = 1;
  hint_num = 5;
  number_answer = 0;
  hintclicked = false;
  hintblocked = false;
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
    return Scaffold(
        backgroundColor: blackmode == true ? blackmodecolor : notblackmodecolor,
        appBar: AppBar(
          //automaticallyImplyLeading: false,
          title: Text("단어 퀴즈"),
          backgroundColor:
              blackmode == true ? blackmodecolor : notblackmodecolor,
          centerTitle: false,
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
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          "$idx/10",
                          style: TextStyle(
                              color: blackmode == true
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
                                          showhint(context, datas);
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
                      datas[order]["name"].toString(),
                      style: TextStyle(
                          color:
                              blackmode == true ? Colors.white : Colors.black,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 40,
              color: blackmode == true ? Colors.white : Colors.black,
            ),
            Expanded(
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Card(
                      color: blackmode == true
                          ? blackmodecolor
                          : notblackmodecolor,
                      elevation: 0.0,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 13.0),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: blackmode == true
                                    ? Colors.white
                                    : Colors.teal),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          tileColor: blackmode == true
                              ? blackmodecolor
                              : Colors.blue[300],
                          leading: Text(
                            (index + 1).toString() + ".",
                            style: TextStyle(
                                color: blackmode == true
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
                                color: blackmode == true
                                    ? Colors.white
                                    : blackmodecolor),
                          ),
                          onTap: () {
                            if (datas[order]["options"][index] ==
                                    datas[order]["answer"] &&
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
                              endpage(context, '/word');
                            }
                          });
                        },
                        child: Text(
                          "다음",
                          style: TextStyle(color: Colors.white),
                        )),
                  )
                : SizedBox()
          ],
        ));
  }
}
