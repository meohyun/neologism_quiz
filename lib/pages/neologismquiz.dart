import 'package:flutter/material.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:neologism/quizdata.dart';
import 'dart:math';

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

setinit() {
  answer = false;
  order = makenumber(80)[0];
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
          title: Text("신조어 퀴즈"),
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
              height: MediaQuery.of(context).size.height * 0.3,
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
                                          showhint(context);
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
            Expanded(
              child: Container(
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
            ),
            answershow == true
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
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
                              endpage(context);
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
                            Navigator.pushNamed(context, '/neologism');
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

showhint(context) {
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
                  datas[order]["hint"],
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
