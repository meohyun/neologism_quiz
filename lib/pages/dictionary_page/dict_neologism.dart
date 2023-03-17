import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/neo_function/dict_func.dart';
import 'package:neologism/pages/dictionary_page/dict_info.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:neologism/datas/quizdata.dart';
import 'package:neologism/widgets/bottom_navigation.dart';

var category_filtered = "";
int category_index = 0;
bool category_selected = false;

setinit() {
  category_filtered = "전체";
  int category_index = 0;
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
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text(
            "신조어 사전",
            style: TextStyle(
                color: Get.find<BlackModeController>().blackmode == true
                    ? Colors.white
                    : blackmodecolor),
          ),
          centerTitle: false,
          elevation: 0.0,
          backgroundColor: Get.find<BlackModeController>().blackmode == true
              ? blackmodecolor
              : notblackmodecolor,
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(
                      context: context, delegate: CustomSearchDelegate());
                },
                icon: const Icon(Icons.search)),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        bottomNavigationBar: const MyBottomnavigator(),
        backgroundColor: Get.find<BlackModeController>().blackmode == true
            ? blackmodecolor
            : notblackmodecolor,
        body: Column(
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: CategoryButton(
                  onChanged: (value) =>
                      setState(() => category_filtered = value),
                  changedindex: (value) =>
                      setState(() => category_index = value),
                )),
            category_index == 0
                ? Expanded(
                    child: Container(
                      color: Get.find<BlackModeController>().blackmode == true
                          ? blackmodecolor
                          : notblackmodecolor,
                      child: ListView.builder(
                          itemCount: datas.length,
                          itemBuilder: ((context, index) {
                            return Card(
                              color:
                                  Get.find<BlackModeController>().blackmode ==
                                          true
                                      ? blackmodecolor
                                      : notblackmodecolor,
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                tileColor:
                                    Get.find<BlackModeController>().blackmode ==
                                            true
                                        ? Colors.black
                                        : Colors.white,
                                title: Text(
                                  datas[index]["desc_title"],
                                  style: TextStyle(
                                      color: Get.find<BlackModeController>()
                                                  .blackmode ==
                                              true
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
      ),
    );
  }
}
