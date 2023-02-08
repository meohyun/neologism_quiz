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
                child: Blluettin(),
              ),
            ));
  }
}

class Blluettin extends StatelessWidget {
  const Blluettin({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!.displayName;
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
                final d24 = DateFormat('yyyy.MM.dd HH:mm').format(dt);
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BulletinPost(
                            index: index,
                            name: postDocs[index]["name"],
                            content: postDocs[index]["content"],
                            user: user,
                            datetime: d24,
                            like: postDocs[index]["like"],
                            dislike: postDocs[index]["dislike"])));
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Get.find<BlackModeController>().blackmode
                              ? Colors.white
                              : blackmodecolor,
                          width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                postDocs[index]["name"],
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Get.find<BlackModeController>()
                                            .blackmode
                                        ? Colors.white
                                        : blackmodecolor),
                              ),
                              Text(user.toString())
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
                                      Get.find<BlackModeController>().blackmode
                                          ? Colors.white
                                          : blackmodecolor),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }));
        });
  }
}
