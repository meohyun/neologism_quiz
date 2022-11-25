import 'package:flutter/material.dart';
import 'package:neologism/neo_function/dict_func.dart';
import 'package:neologism/pages/dict_info.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:neologism/datas/quizdata.dart';

var category_filtered = "";
bool category_selected = false;

setinit() {
  category_filtered = "전체";
}

class NeologismDict extends StatefulWidget {
  @override
  State<NeologismDict> createState() => _NeologismDictState();
}

class _NeologismDictState extends State<NeologismDict> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setinit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "신조어 사전",
          style: TextStyle(
              color: blackmode == true ? Colors.white : blackmodecolor),
        ),
        centerTitle: false,
        elevation: 0.0,
        backgroundColor: blackmode == true ? blackmodecolor : notblackmodecolor,
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: CustomSearchDelegate());
              },
              icon: Icon(Icons.search)),
          SizedBox(
            width: 10,
          ),
          // BlackModeButton(
          //   ModeChanged: (value) => setState(() => blackmode = value),
          // )
        ],
      ),
      backgroundColor: blackmode == true ? blackmodecolor : notblackmodecolor,
      body: Column(
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 35,
              child: CategoryButton(
                  onChanged: (value) =>
                      setState(() => category_filtered = value))),
          category_filtered == "전체"
              ? Expanded(
                  child: Container(
                    color:
                        blackmode == true ? blackmodecolor : notblackmodecolor,
                    child: ListView.builder(
                        itemCount: datas.length,
                        itemBuilder: ((context, index) {
                          return Card(
                            color: blackmode == true
                                ? blackmodecolor
                                : notblackmodecolor,
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              tileColor: blackmode == true
                                  ? Colors.black
                                  : Colors.white,
                              title: Text(
                                datas[index]["desc_title"],
                                style: TextStyle(
                                    color: blackmode == true
                                        ? Colors.white
                                        : blackmodecolor,
                                    fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                // 1. 인포 페이지에 index값을 전달
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        DictInfo(index: index)));
                              },
                            ),
                          );
                        })),
                  ),
                )
              : CategoryFilter(),
        ],
      ),
    );
  }
}
