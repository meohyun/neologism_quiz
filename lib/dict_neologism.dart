import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:neologism/dict_info.dart';
import 'package:neologism/quizdata.dart';
import 'main.dart';

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
          BlackModeButton(
            ModeChanged: (value) => setState(() => blackmode = value),
          )
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
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.white),
                                //borderRadius: BorderRadius.circular(15),
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

// 검색 기능
class CustomSearchDelegate extends SearchDelegate {
  bool matching = false;
  @override
  Widget buildLeading(context) {
    return (IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back)));
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
    return Container(
        color: blackmode == true ? blackmodecolor : notblackmodecolor,
        child: ListView.builder(
            itemCount: matchQuery.length,
            itemBuilder: ((context, index) {
              var result = matchQuery[index];
              return Card(
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white),
                    //borderRadius: BorderRadius.circular(15),
                  ),
                  tileColor: blackmode == true ? Colors.black : Colors.white,
                  title: Text(
                    result,
                    style: TextStyle(
                        color:
                            blackmode == true ? Colors.white : blackmodecolor,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    // 1. 인포 페이지에 index값을 전달
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DictInfo(index: idx_res)));
                  },
                ),
              );
            })));
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
    return Column(
      children: [
        Expanded(
            child: Container(
          color: blackmode == true ? blackmodecolor : notblackmodecolor,
          child: ListView.builder(
              itemCount: matchQuery.length,
              itemBuilder: ((context, index) {
                var result = matchQuery[index];
                return query == ''
                    ? Container()
                    : Card(
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white),
                            //borderRadius: BorderRadius.circular(15),
                          ),
                          tileColor:
                              blackmode == true ? Colors.black : Colors.white,
                          title: Text(
                            result,
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
                                    DictInfo(index: matchindex[index])));
                          },
                        ),
                      );
              })),
        )),
      ],
    );
  }

  @override
  List<Widget> buildActions(context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }
}

// 카테고리 버튼
class CategoryButton extends StatefulWidget {
  CategoryButton({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

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
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
            child: TextButton(
              onPressed: () {
                widget.onChanged(datas[index]["category"]);
                setState(() {
                  pressedAttentionIndex = index;
                  category_selected = true;
                });
              },
              child: Text(
                datas[index]["category"],
                style: TextStyle(color: blackmodecolor),
              ),
              style: TextButton.styleFrom(
                backgroundColor:
                    pressAttention ? Colors.amberAccent : Colors.grey[200],
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ));
        }));
  }
}

class CategoryFilter extends StatefulWidget {
  CategoryFilter({super.key});

  @override
  State<CategoryFilter> createState() => _CategoryFilterState();
}

class _CategoryFilterState extends State<CategoryFilter> {
  @override
  Widget build(BuildContext context) {
    List<String> matchQuery = [];
    List<int> matchindex = [];

    for (int i = 0; i < datas.length; i++) {
      if (datas[i]['category'].toLowerCase().contains(category_filtered)) {
        matchQuery.add(datas[i]['desc_title']);
        matchindex.add(i);
      }
    }
    return Expanded(
      child: Container(
        color: blackmode == true ? blackmodecolor : notblackmodecolor,
        child: ListView.builder(
            itemCount: matchQuery.length,
            itemBuilder: ((context, index) {
              var result = matchQuery[index];
              return Card(
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white),
                    //borderRadius: BorderRadius.circular(15),
                  ),
                  tileColor: blackmode == true ? Colors.black : Colors.white,
                  title: Text(
                    result,
                    style: TextStyle(
                        color:
                            blackmode == true ? Colors.white : blackmodecolor,
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
    );
  }
}
