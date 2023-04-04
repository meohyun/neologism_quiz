import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/pages/bulletin_pages/post_page.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:intl/intl.dart';

class BulletinTile extends StatelessWidget {
  const BulletinTile({super.key, this.docs});

  final docs;

  @override
  Widget build(BuildContext context) {
    final userid = FirebaseAuth.instance.currentUser!.uid;
    return ListView.builder(
        itemCount: docs.length,
        itemBuilder: ((context, index) {
          final timestamp = docs[index]['time'];
          DateTime dt = timestamp.toDate();
          final d24 = DateFormat('yy/MM/dd HH:mm').format(dt);
          return Padding(
            padding: const EdgeInsets.only(bottom: 1),
            child: GestureDetector(
              onTap: () {
                if (docs[index]["likes"][userid] == null &&
                    docs[index]['dislikes'][userid] == null) {
                  FirebaseFirestore.instance
                      .collection('post')
                      .doc(docs[index].id)
                      .update(
                          {'likes.$userid': false, 'dislikes.$userid': false});
                }
                if (docs[index]["likes"][userid] != null) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BulletinPost(
                            name: docs[index]["name"],
                            content: docs[index]["content"],
                            datetime: d24,
                            like: docs[index]["like"],
                            dislike: docs[index]["dislike"],
                            admin: docs[index]["admin"]["usernickname"],
                            adminid: docs[index]["admin"]["userid"],
                            chats: docs[index]["chats"],
                            docId: docs[index].id,
                            userlike: docs[index]["likes"][userid],
                            userdislike: docs[index]["dislikes"][userid],
                          )));
                }
              },
              child: GetBuilder(
                init: BlackModeController(),
                builder: (_) => Container(
                  height: 100,
                  decoration: BoxDecoration(
                      color: Get.find<BlackModeController>().blackmode
                          ? blackmodecolor
                          : Colors.deepPurple[50],
                      border: Border(
                        bottom: BorderSide(
                            width: 2,
                            color: Get.find<BlackModeController>().blackmode
                                ? Colors.white
                                : Colors.black),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                docs[index]["name"] +
                                    "  [${docs[index]["chats"].length}]",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Get.find<BlackModeController>()
                                            .blackmode
                                        ? Colors.white
                                        : blackmodecolor),
                              ),
                              Text(
                                  docs[index]["admin"]["usernickname"]
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Get.find<BlackModeController>()
                                              .blackmode
                                          ? Colors.white
                                          : blackmodecolor))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Opacity(
                                opacity: 0.5,
                                child: Text(
                                  d24,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Get.find<BlackModeController>()
                                              .blackmode
                                          ? Colors.white
                                          : blackmodecolor),
                                ),
                              ),
                              Opacity(
                                opacity: 0.5,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.thumb_up,
                                      size: 20,
                                      color: Get.find<BlackModeController>()
                                              .blackmode
                                          ? Colors.white
                                          : blackmodecolor,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(docs[index]["like"].toString(),
                                        style: TextStyle(
                                            color:
                                                Get.find<BlackModeController>()
                                                        .blackmode
                                                    ? Colors.white
                                                    : blackmodecolor)),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.thumb_down,
                                      size: 20,
                                      color: Get.find<BlackModeController>()
                                              .blackmode
                                          ? Colors.white
                                          : blackmodecolor,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(docs[index]["dislike"].toString(),
                                        style: TextStyle(
                                            color:
                                                Get.find<BlackModeController>()
                                                        .blackmode
                                                    ? Colors.white
                                                    : blackmodecolor)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }));
  }
}
