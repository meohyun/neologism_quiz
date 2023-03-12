import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:neologism/widgets/bulletin.dart';
import 'package:intl/intl.dart';
import '../pages/bulletin_pages/post_page.dart';

class BulletinSearch extends StatefulWidget {
  const BulletinSearch({super.key});

  @override
  State<BulletinSearch> createState() => _BulletinSearchState();
}

class _BulletinSearchState extends State<BulletinSearch> {
  String name = "";
  @override
  Widget build(BuildContext context) {
    final blackmode = Get.find<BlackModeController>().blackmode;
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: blackmode ? blackmodecolor : notblackmodecolor,
        appBar: AppBar(
          backgroundColor: blackmode ? blackmodecolor : notblackmodecolor,
          title: Card(
            child: TextField(
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search), hintText: "검색어를 입력해주세요."),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('post').snapshots(),
            builder: (context, snapshots) {
              if (snapshots.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                  itemCount: snapshots.data!.docs.length,
                  itemBuilder: ((context, index) {
                    final datas = snapshots.data!.docs;
                    final timestamp = datas[index]['time'];
                    DateTime dt = timestamp.toDate();
                    final d24 = DateFormat('yy/MM/dd HH:mm').format(dt);

                    if (name.isEmpty) {
                      // search history
                      return Container();
                    }
                    if (datas[index]['name']
                        .toString()
                        .toLowerCase()
                        .startsWith(name.toLowerCase())) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return BulletinPost(
                                name: datas[index]["name"],
                                content: datas[index]["content"],
                                datetime: d24,
                                like: datas[index]["like"],
                                dislike: datas[index]["dislike"],
                                admin: datas[index]["admin"]["usernickname"],
                                chats: datas[index]["chats"],
                                docId: datas[index].id,
                                userlike: datas[index]["likes"][userid],
                                userdislike: datas[index]["dislikes"][userid],
                              );
                            }));
                          },
                          child: SizedBox(
                            height: 80,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(12,10, 0, 5),
                                  child: Text(
                                    datas[index]["name"],
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: blackmode
                                            ? Colors.white
                                            : blackmodecolor),
                                  ),
                                ),
                                const Divider(
                                  height: 30,
                                  thickness: 5,
                                )
                              ],
                            ),
                          ));
                    }
                    return Container();
                  }));
            }),
      ),
    );
  }
}
