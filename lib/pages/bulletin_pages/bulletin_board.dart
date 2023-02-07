import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/pages/bulletin_pages/post_page.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:intl/intl.dart';

class Bulletin_Board extends StatelessWidget {
  const Bulletin_Board({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: BlackModeController(),
        builder: (_) => Scaffold(
              appBar: AppBar(
                backgroundColor: Get.find<BlackModeController>().blackmode
                    ? blackmodecolor
                    : notblackmodecolor,
                title: Text(
                  "건의 게시판",
                  style: TextStyle(
                    color: Get.find<BlackModeController>().blackmode
                        ? Colors.white
                        : blackmodecolor,
                  ),
                ),
                actions: [
                  CircleAvatar(
                    backgroundColor: Get.find<BlackModeController>().blackmode
                        ? blackmodecolor
                        : notblackmodecolor,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/create');
                        },
                        icon: Icon(Icons.add,
                            color: Get.find<BlackModeController>().blackmode
                                ? Colors.white
                                : blackmodecolor)),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.search,
                        color: Get.find<BlackModeController>().blackmode
                            ? Colors.white
                            : blackmodecolor,
                      ))
                ],
              ),
              body: Container(
                  color: Get.find<BlackModeController>().blackmode
                      ? blackmodecolor
                      : notblackmodecolor,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Bluettin()),
            ));
  }
}

class Bluettin extends StatelessWidget {
  const Bluettin({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!.displayName;
    final board = FirebaseFirestore.instance.collection('post');
    return StreamBuilder(
        stream: board.orderBy('time', descending: true).snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final postDocs = snapshot.data!.docs;

          return ListView.builder(
              itemCount: postDocs.length,
              itemBuilder: ((context, index) {
                final timestamp = postDocs[index]['time'];
                DateTime dt = timestamp.toDate();
                final d24 = DateFormat('yyyy.MM.dd HH:mm').format(dt);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    tileColor: Get.find<BlackModeController>().blackmode == true
                        ? Colors.black
                        : Colors.white,
                    title: Text(
                      postDocs[index]['name'],
                      style: TextStyle(
                        color: Get.find<BlackModeController>().blackmode
                            ? Colors.white
                            : blackmodecolor,
                      ),
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Opacity(
                        opacity: 0.7,
                        child: Column(
                          children: [
                            Text(
                              d24,
                              style: TextStyle(
                                  color:
                                      Get.find<BlackModeController>().blackmode
                                          ? Colors.white
                                          : blackmodecolor),
                            ),
                            Text(
                              user.toString(),
                              style: TextStyle(
                                color: Get.find<BlackModeController>().blackmode
                                    ? Colors.white
                                    : blackmodecolor,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BulletinPost(
                                index: index,
                                name: postDocs[index]["name"],
                                content: postDocs[index]["content"],
                                user: user,
                                datetime: d24,
                              )));
                    },
                  ),
                );
              }));
        });
  }
}
