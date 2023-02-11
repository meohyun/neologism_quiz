import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/getx/postlike.dart';
import 'package:neologism/neo_function/bulletin_func.dart';
import 'package:neologism/pages/bulletin_pages/CRUD.dart';
import 'package:neologism/pages/bulletin_pages/chatbox.dart';
import 'package:neologism/pages/startpage.dart';

final blackcontroller = Get.find<BlackModeController>();

class BulletinPost extends StatefulWidget {
  const BulletinPost(
      {super.key,
      this.index,
      this.user,
      this.name,
      this.content,
      this.datetime,
      this.like,
      this.dislike,
      this.admin,
      this.docId});

  final index;
  final user;
  final name;
  final content;
  final datetime;
  final like;
  final dislike;
  final admin;
  final docId;

  @override
  State<BulletinPost> createState() => _BulletinPostState();
}

class _BulletinPostState extends State<BulletinPost> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    chatController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    Get.put(PostLikeController());

    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => Scaffold(
          backgroundColor:
              blackcontroller.blackmode ? blackmodecolor : notblackmodecolor,
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back)),
            title: Text("건의 게시판",
                style: TextStyle(
                  color:
                      blackcontroller.blackmode ? Colors.white : blackmodecolor,
                )),
            elevation: 0.0,
            backgroundColor:
                blackcontroller.blackmode ? blackmodecolor : notblackmodecolor,
            actions: widget.admin == FirebaseAuth.instance.currentUser!.uid
                ? ([
                    BulletinUpdateIcon(
                      name: widget.name,
                      content: widget.content,
                      docId: widget.docId,
                    ),
                    BulletinDeleteIcon(
                      docId: widget.docId,
                    )
                  ])
                : null,
          ),
          body: LayoutBuilder(builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: Container(
                    color: blackcontroller.blackmode
                        ? blackmodecolor
                        : notblackmodecolor,
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
                                    border: Border.all(
                                        width: 2, color: Colors.black),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          widget.name,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border:
                                    Border.all(width: 2, color: Colors.black),
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.content,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Obx(() {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 100,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Get.find<
                                                                  PostLikeController>()
                                                              .likeclicked
                                                              .value
                                                          ? Colors.blue[200]
                                                          : Colors.white,
                                                      border: Border.all(
                                                          width: 2,
                                                          color: Colors.black)),
                                                  child: GestureDetector(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                            Icons.thumb_up_alt),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10),
                                                          child: Text("좋아요  " +
                                                              widget.like
                                                                  .toString()),
                                                        )
                                                      ],
                                                    ),
                                                    onTap: () {
                                                      Get.put(PostLikeController())
                                                          .like();
                                                      print(widget.docId);
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                Container(
                                                  width: 100,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      color: Get.find<
                                                                  PostLikeController>()
                                                              .dislikeclicked
                                                              .value
                                                          ? Colors.red[200]
                                                          : Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          width: 2,
                                                          color: Colors.black)),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Get.put(PostLikeController())
                                                          .dislike();
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(Icons
                                                            .thumb_down_alt),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10),
                                                          child: Text("싫어요  " +
                                                              widget.dislike
                                                                  .toString()),
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
                                      ChatContainer(
                                        docId: widget.docId,
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
              ),
            );
          })),
    );
  }
}
