import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/pages/bulletin_pages/post_page.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:intl/intl.dart';

String usernickname = "";

class Bulletin_Board extends StatelessWidget {
  const Bulletin_Board({super.key, this.userdocid});

  final userdocid;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: BlackModeController(),
        builder: (_) => Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    icon: Icon(Icons.arrow_back)),
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
              body: Stack(
                children: [
                  Positioned(
                    child: Container(
                      color: Get.find<BlackModeController>().blackmode
                          ? blackmodecolor
                          : notblackmodecolor,
                    ),
                  ),
                  Positioned(
                    child: Container(
                      color: Colors.white30,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Blluettin(
                        userdocid: userdocid,
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}

class Blluettin extends StatelessWidget {
  Blluettin({super.key, this.userdocid});

  final userdocid;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!.displayName;
    final userid = FirebaseAuth.instance.currentUser!.uid;
    final board = FirebaseFirestore.instance.collection('post');
    return StreamBuilder(
        stream: board.orderBy('time', descending: true).snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final postDocs = snapshot.data!.docs;
          return ListView.builder(
              itemCount: postDocs.length,
              itemBuilder: ((context, index) {
                final timestamp = postDocs[index]['time'];
                DateTime dt = timestamp.toDate();
                final d24 = DateFormat('yy/MM/dd HH:mm').format(dt);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 1),
                  child: GestureDetector(
                    onTap: () {
                      if (postDocs[index]["likes"][userid] == null &&
                          postDocs[index]['dislikes'][userid] == null) {
                        FirebaseFirestore.instance
                            .collection('post')
                            .doc(postDocs[index].id)
                            .update({
                          'likes.$userid': false,
                          'dislikes.$userid': false
                        });
                      }
                      if (postDocs[index]["likes"][userid] != null) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => BulletinPost(
                                  index: index,
                                  name: postDocs[index]["name"],
                                  content: postDocs[index]["content"],
                                  datetime: d24,
                                  like: postDocs[index]["like"],
                                  dislike: postDocs[index]["dislike"],
                                  admin: postDocs[index]["admin"]
                                      ["usernickname"],
                                  docId: postDocs[index].id,
                                  userdocid: userdocid,
                                  userlike: postDocs[index]["likes"][userid],
                                  userdislike: postDocs[index]["dislikes"]
                                      [userid],
                                )));
                      }
                    },
                    child: GetBuilder(
                        init: BlackModeController(),
                        builder: (context) {
                          return Container(
                            height: 100,
                            decoration: const BoxDecoration(
                                border: Border(
                              bottom: BorderSide(width: 1, color: Colors.grey),
                            )),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          postDocs[index]["name"],
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Get.find<
                                                          BlackModeController>()
                                                      .blackmode
                                                  ? Colors.white
                                                  : blackmodecolor),
                                        ),
                                        Text(postDocs[index]["admin"]
                                                ["usernickname"]
                                            .toString())
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Opacity(
                                      opacity: 0.5,
                                      child: Text(
                                        d24,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                Get.find<BlackModeController>()
                                                        .blackmode
                                                    ? Colors.white
                                                    : blackmodecolor),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                );
              }));
        });
  }
}
