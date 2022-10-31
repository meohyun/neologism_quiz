import 'package:flutter/material.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:neologism/quizdata.dart';

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
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "신조어 사전",
          style: TextStyle(
              color: blackmode == true ? Colors.white : blackmodecolor),
        ),
        backgroundColor: blackmode == true ? blackmodecolor : notblackmodecolor,
        shadowColor: blackmode == true ? Colors.white : blackmodecolor,
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: blackmode == true ? Colors.white : blackmodecolor,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          BlackModeButton(
            ModeChanged: (value) => setState(() => blackmode = value),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              color: blackmode == true ? blackmodecolor : notblackmodecolor,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        height: 150,
                        child: Column(
                          children: [
                            Text(
                              datas[widget.index]["desc_title"],
                              style: TextStyle(
                                  fontSize: 28.0,
                                  color: blackmode == true
                                      ? Colors.white
                                      : blackmodecolor,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              datas[widget.index]["desc"],
                              style: TextStyle(
                                  color: blackmode == true
                                      ? Colors.white
                                      : blackmodecolor,
                                  fontSize: 20.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 0.0,
                      color: blackmode == true ? Colors.white : blackmodecolor,
                    ),
                    SizedBox(
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("예시: " + datas[widget.index]["example"],
                            style: TextStyle(
                                color: blackmode == true
                                    ? Colors.white
                                    : blackmodecolor,
                                fontSize: 18.0)),
                      ),
                    )
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
