import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/pages/bulletin_pages/post_page.dart';
import 'package:neologism/pages/startpage.dart';

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
    final user = FirebaseAuth.instance.currentUser;
    final board = FirebaseFirestore.instance.collection('post');
    return StreamBuilder(
        stream: board.orderBy('time', descending: true).snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final chatDocs = snapshot.data!.docs;
          return ListView.builder(
              itemCount: chatDocs.length,
              itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(chatDocs[index]['name']),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BulletinPost(
                                index: index,
                              )));
                    },
                  ),
                );
              }));
        });
  }
}
