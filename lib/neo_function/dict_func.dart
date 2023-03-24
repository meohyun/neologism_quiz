import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/pages/dictionary_page/dict_info.dart';
import 'package:neologism/pages/dictionary_page/dict_neologism.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:neologism/datas/quizdata.dart';

// 검색 기능
class CustomSearchDelegate extends SearchDelegate {
  @override
  Widget buildLeading(context) {
    return (IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back)));
  }

  @override
  Widget buildResults(context) {
    int idx_res = 0;
    List<String> matchQuery = [];

    for (int i = 0; i < datas.length; i++) {
      if (datas[i]['desc_title'].toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(datas[i]['desc_title']);
        idx_res = i;
      }
    }
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => Container(
          color: Get.find<BlackModeController>().blackmode == true
              ? blackmodecolor
              : notblackmodecolor,
          child: ListView.builder(
              itemCount: matchQuery.length,
              itemBuilder: ((context, index) {
                var result = matchQuery[index];
                return Card(
                  color: Get.find<BlackModeController>().blackmode == true
                      ? blackmodecolor
                      : notblackmodecolor,
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    tileColor: Get.find<BlackModeController>().blackmode == true
                        ? Colors.black
                        : Colors.white,
                    title: Text(
                      result,
                      style: TextStyle(
                          color:
                              Get.find<BlackModeController>().blackmode == true
                                  ? Colors.white
                                  : blackmodecolor,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      // 1. 인포 페이지에 index값을 전달
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DictInfo(index: idx_res)));
                    },
                  ),
                );
              }))),
    );
  }

  @override
  Widget buildSuggestions(context) {
    List<String> matchQuery = [];
    List<int> matchindex = [];
    for (int i = 0; i < datas.length; i++) {
      if (datas[i]['desc_title'].toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(datas[i]['desc_title']);
        matchindex.add(i);
      }
    }
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => Column(
        children: [
          Expanded(
              child: Container(
            color: Get.find<BlackModeController>().blackmode == true
                ? blackmodecolor
                : notblackmodecolor,
            child: ListView.builder(
                itemCount: matchQuery.length,
                itemBuilder: ((context, index) {
                  var result = matchQuery[index];
                  return query == ''
                      ? Container()
                      : Card(
                          color:
                              Get.find<BlackModeController>().blackmode == true
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
                              result,
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
                                      DictInfo(index: matchindex[index])));
                            },
                          ),
                        );
                })),
          )),
        ],
      ),
    );
  }

  @override
  List<Widget> buildActions(context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }
}

// 카테고리 버튼
class CategoryButton extends StatefulWidget {
  const CategoryButton(
      {super.key, required this.onChanged, required this.changedindex});

  final ValueChanged<String> onChanged;
  final ValueChanged<int> changedindex;

  @override
  State<CategoryButton> createState() => _CategorysState();
}

class _CategorysState extends State<CategoryButton> {
  int pressedAttentionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: ((context, index) {
          final pressAttention = pressedAttentionIndex == index;
          return (Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 0.0, 0.0, 5.0),
            child: SizedBox(
              width: 70,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    pressedAttentionIndex = index;
                    category_selected = true;
                  });
                  widget.onChanged(datas[pressedAttentionIndex]["category"]);
                  widget.changedindex(pressedAttentionIndex);
                },
                style: TextButton.styleFrom(
                  backgroundColor:
                      pressAttention ? Colors.amberAccent : Colors.grey[200],
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: index != 0
                    ? Text(
                        datas[index]["category"],
                        style: TextStyle(color: blackmodecolor, fontSize: 17),
                      )
                    : Text(
                        "전체",
                        style: TextStyle(color: blackmodecolor, fontSize: 17),
                      ),
                
              ),
            ),
          ));
        }));
  }
}

class CategoryFilter extends StatefulWidget {
  const CategoryFilter({super.key,this.category});

  final category;

  @override
  State<CategoryFilter> createState() => _CategoryFilterState();
}

class _CategoryFilterState extends State<CategoryFilter> {
  @override
  Widget build(BuildContext context) {
    List<String> matchQuery = [];
    List<int> matchindex = [];

    for (int i = 0; i < datas.length; i++) {
      if (datas[i]['category'].toLowerCase().contains(widget.category)) {
        matchQuery.add(datas[i]['desc_title']);
        matchindex.add(i);
      }
    }

    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => Expanded(
        child: Container(
          color: Get.find<BlackModeController>().blackmode == true
              ? blackmodecolor
              : notblackmodecolor,
          child: ListView.builder(
              itemCount: matchQuery.length,
              itemBuilder: ((context, index) {
                var result = matchQuery[index];
                return Card(
                  color: Get.find<BlackModeController>().blackmode == true
                      ? blackmodecolor
                      : notblackmodecolor,
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    tileColor: Get.find<BlackModeController>().blackmode == true
                        ? Colors.black
                        : Colors.white,
                    title: Text(
                      result,
                      style: TextStyle(
                          color:
                              Get.find<BlackModeController>().blackmode == true
                                  ? Colors.white
                                  : blackmodecolor,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      // 1. 인포 페이지에 index값을 전달
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              DictInfo(index: matchindex[index])));
                    },
                  ),
                );
              })),
        ),
      ),
    );
  }
}
