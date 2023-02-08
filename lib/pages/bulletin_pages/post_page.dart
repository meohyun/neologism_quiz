import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/getx/postlike.dart';
import 'package:neologism/pages/startpage.dart';

class BulletinPost extends StatefulWidget {
  const BulletinPost(
      {super.key,
      this.index,
      this.user,
      this.name,
      this.content,
      this.datetime,
      this.like,
      this.dislike});

  final index;
  final user;
  final name;
  final content;
  final datetime;
  final like;
  final dislike;

  @override
  State<BulletinPost> createState() => _BulletinPostState();
}

class _BulletinPostState extends State<BulletinPost> {
  @override
  Widget build(BuildContext context) {
    Get.put(PostLikeController());
    final blackcontroller = Get.find<BlackModeController>();
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text("건의 게시판",
              style: TextStyle(
                color:
                    blackcontroller.blackmode ? Colors.white : blackmodecolor,
              )),
          elevation: 0.0,
          backgroundColor:
              blackcontroller.blackmode ? blackmodecolor : notblackmodecolor,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(CupertinoIcons.pen),
              iconSize: 30,
              color: blackcontroller.blackmode ? Colors.white : blackmodecolor,
            ),
            IconButton(
                onPressed: () {},
                icon: Icon(CupertinoIcons.delete,
                    color: blackcontroller.blackmode
                        ? Colors.white
                        : blackmodecolor))
          ],
        ),
        body: Container(
          color: blackcontroller.blackmode ? blackmodecolor : notblackmodecolor,
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 80,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(width: 2, color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.user.toString(),
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                                Text(widget.datetime.toString()),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                widget.name,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 500,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.content,
                          style: TextStyle(fontSize: 18),
                        ),
                        Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Obx(() {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color:
                                                Get.find<PostLikeController>()
                                                        .likeclicked
                                                        .value
                                                    ? Colors.blue[200]
                                                    : Colors.white,
                                            border: Border.all(
                                                width: 2, color: Colors.black)),
                                        child: GestureDetector(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.thumb_up_alt),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text("좋아요  " +
                                                    widget.like.toString()),
                                              )
                                            ],
                                          ),
                                          onTap: () {
                                            Get.put(PostLikeController())
                                                .like();
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Container(
                                        width: 100,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color:
                                                Get.find<PostLikeController>()
                                                        .dislikeclicked
                                                        .value
                                                    ? Colors.red[200]
                                                    : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                width: 2, color: Colors.black)),
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.put(PostLikeController())
                                                .dislike();
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.thumb_down_alt),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text("싫어요  " +
                                                    widget.dislike.toString()),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                })),
                            const Divider(
                              height: 50,
                              thickness: 1,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: const TextField(
                                decoration: InputDecoration(
                                    hintText: "댓글을 남겨보세요.",
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2, color: Colors.grey)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2, color: Colors.grey))),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
