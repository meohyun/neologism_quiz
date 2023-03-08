import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:neologism/datas/quizdata.dart';

class DictInfo extends StatefulWidget {
  // 2. required를 통해서 필수 argument로 index를 받음.
  const DictInfo({super.key, required this.index});

  // 3. 필드를 final 형태로 구성.
  final index;

  @override
  State<DictInfo> createState() => _DictInfoState();
}

class _DictInfoState extends State<DictInfo> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            "신조어 사전",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Get.find<BlackModeController>().blackmode == true
                    ? Colors.white
                    : blackmodecolor),
          ),
          backgroundColor: Get.find<BlackModeController>().blackmode == true
              ? blackmodecolor
              : notblackmodecolor,
          shadowColor: Get.find<BlackModeController>().blackmode == true
              ? Colors.white
              : blackmodecolor,
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              color: Get.find<BlackModeController>().blackmode == true
                  ? Colors.white
                  : blackmodecolor,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                color: Get.find<BlackModeController>().blackmode == true
                    ? blackmodecolor
                    : notblackmodecolor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 15, 10, 5),
                          child: Text("분류: " + datas[widget.index]["category"],
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color:
                                      Get.find<BlackModeController>().blackmode ==
                                              true
                                          ? Colors.white
                                          : blackmodecolor,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: Column(
                                children: [
                                  Text(
                                    datas[widget.index]["desc_title"],
                                    style: TextStyle(
                                        fontSize: 28.0,
                                        color: Get.find<BlackModeController>()
                                                    .blackmode ==
                                                true
                                            ? Colors.white
                                            : blackmodecolor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      datas[widget.index]["desc"],
                                      style: TextStyle(
                                          color: Get.find<BlackModeController>()
                                                      .blackmode ==
                                                  true
                                              ? Colors.white
                                              : blackmodecolor,
                                          fontSize: 20.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            height: 50.0,
                            color: Get.find<BlackModeController>().blackmode ==
                                    true
                                ? Colors.white
                                : blackmodecolor,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 30),
                                        child: Text("예시",
                                            style: TextStyle(
                                                color: Get.find<BlackModeController>()
                                                            .blackmode ==
                                                        true
                                                    ? Colors.white
                                                    : blackmodecolor,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Text(datas[widget.index]["example"],
                                        style: TextStyle(
                                            color:
                                                Get.find<BlackModeController>()
                                                            .blackmode ==
                                                        true
                                                    ? Colors.white
                                                    : blackmodecolor,
                                            fontSize: 22)),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
