import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/getx/chatmodify.dart';
import 'package:neologism/pages/bulletin_pages/postCRUD.dart';
import 'package:neologism/pages/bulletin_pages/chatbox.dart';
import 'package:neologism/pages/startpage.dart';

final userid = FirebaseAuth.instance.currentUser!.uid;
bool isLiked = false;
int likeCount = 0;
int dislikeCount = 0;
bool disLiked = false;

class BulletinPost extends StatefulWidget {
  const BulletinPost({
    super.key,
    this.index,
    this.name,
    this.content,
    this.datetime,
    this.like,
    this.dislike,
    this.admin,
    this.chats,
    this.docId,
    this.userlike,
    this.userdislike,
  });

  final index;
  final name;
  final content;
  final datetime;
  final like;
  final dislike;
  final admin;
  final chats;
  final docId;
  final userlike;
  final userdislike;

  @override
  State<BulletinPost> createState() => _BulletinPostState();
}

class _BulletinPostState extends State<BulletinPost> {
  updateChatUser() {
    final user = FirebaseAuth.instance.currentUser!;
    final userid = user.uid;
    final username = user.displayName;

    FirebaseFirestore.instance
        .collection('post')
        .doc(widget.docId)
        .get()
        .then((val) {
      final datas = val.data() as Map<String, dynamic>;
      for (int i = 0; i < datas["chats"].length; i++) {
        if (datas["chats"][i]["user"] == userid) {
          List<dynamic> exchat = [
            {
              "content": datas["chats"][i]["content"],
              "time": datas["chats"][i]["time"],
              "user": datas["chats"][i]["user"],
              "nickname": datas["chats"][i]["nickname"]
            },
          ];
          FirebaseFirestore.instance
              .collection('post')
              .doc(widget.docId)
              .update({"chats": FieldValue.arrayRemove(exchat)});

          List<dynamic> chat = [
            {
              "content": datas["chats"][i]["content"],
              "time": datas["chats"][i]["time"],
              "user": datas["chats"][i]["user"],
              "nickname": username
            },
          ];
          FirebaseFirestore.instance
              .collection('post')
              .doc(widget.docId)
              .update({"chats": FieldValue.arrayUnion(chat)});
        }
      }
    });
  }

  @override
  void initState() {
    Get.put(chatcontroller());
    updateChatUser();
    super.initState();
    setState(() {
      likeCount = widget.like;
      isLiked = widget.userlike;
      disLiked = widget.userdislike;
      dislikeCount = widget.dislike;
    });
    Get.find<chatcontroller>().chatmodified.value = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    chatController.text = "";
  }

  getpostlike() {
    final userid = FirebaseAuth.instance.currentUser!.uid;
    var collection = FirebaseFirestore.instance.collection('post');
    collection.doc(widget.docId).snapshots().listen((docSnapshot) {
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;

        // You can then retrieve the value from the Map like this:
        likeCount = data['like'];
        dislikeCount = data['dislike'];
      }
    });
  }

  postlike() {
    getpostlike();
    if (isLiked && !disLiked) {
      likeCount -= 1;
    }
    if (!isLiked && disLiked) {
      likeCount += 1;
      dislikeCount -= 1;
    }
    if (!isLiked && !disLiked) {
      likeCount += 1;
    }
    setState(() {
      isLiked = !isLiked;
      if (disLiked == true) {
        disLiked = !disLiked;
      }
    });
    FirebaseFirestore.instance.collection('post').doc(widget.docId).update({
      'likes.$userid': isLiked,
      'like': likeCount,
      'dislikes.$userid': disLiked,
      'dislike': dislikeCount
    });
  }

  postdislike() {
    getpostlike();
    if (!isLiked && disLiked) {
      dislikeCount -= 1;
    }
    if (isLiked && !disLiked) {
      dislikeCount += 1;
      likeCount -= 1;
    }
    if (!isLiked && !disLiked) {
      dislikeCount += 1;
    }
    setState(() {
      disLiked = !disLiked;
      if (isLiked == true) {
        isLiked = !isLiked;
      }
    });
    FirebaseFirestore.instance.collection('post').doc(widget.docId).update({
      'likes.$userid': isLiked,
      'like': likeCount,
      'dislikes.$userid': disLiked,
      'dislike': dislikeCount
    });
  }

  @override
  Widget build(BuildContext context) {
    final blackcontroller = Get.find<BlackModeController>();
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => Scaffold(
          backgroundColor:
              blackcontroller.blackmode ? blackmodecolor : notblackmodecolor,
          appBar: AppBar(
            centerTitle: false,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back)),
            title: Text("게시판",
                style: TextStyle(
                  color:
                      blackcontroller.blackmode ? Colors.white : blackmodecolor,
                )),
            elevation: 0.0,
            backgroundColor:
                blackcontroller.blackmode ? blackmodecolor : notblackmodecolor,
            actions:
                widget.admin == FirebaseAuth.instance.currentUser!.displayName
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
              physics: const ClampingScrollPhysics(),
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
                                height: 70,
                                decoration: BoxDecoration(
                                    color: blackcontroller.blackmode
                                        ? blackmodecolor
                                        : Colors.grey[300],
                                    border: Border.all(
                                        width: 2,
                                        color: blackcontroller.blackmode
                                            ? Colors.grey.shade300
                                            : blackmodecolor),
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
                                            widget.admin.toString(),
                                            style: TextStyle(
                                                color: blackcontroller.blackmode
                                                    ? Colors.white
                                                    : blackmodecolor),
                                          ),
                                          const SizedBox(
                                            width: 50,
                                          ),
                                          Text(
                                            widget.datetime.toString(),
                                            style: TextStyle(
                                                color: blackcontroller.blackmode
                                                    ? Colors.white
                                                    : blackmodecolor),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(widget.name,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: blackcontroller.blackmode
                                                    ? Colors.white
                                                    : blackmodecolor)),
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
                                color: blackcontroller.blackmode
                                    ? blackmodecolor
                                    : Colors.grey[300],
                                border: Border.all(
                                    width: 2,
                                    color: blackcontroller.blackmode
                                        ? Colors.grey.shade300
                                        : Colors.black),
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
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: blackcontroller.blackmode
                                            ? Colors.white
                                            : blackmodecolor),
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(top: 40),
                                          child: Row(
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
                                                      color: isLiked
                                                          ? Colors.blue[300]
                                                          : Colors.white,
                                                      border: Border.all(
                                                          width: 2,
                                                          color: Colors.black)),
                                                  child: GestureDetector(
                                                    onDoubleTap: postlike,
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
                                                              likeCount
                                                                  .toString()),
                                                        )
                                                      ],
                                                    ),
                                                  )),
                                              const SizedBox(width: 20),
                                              Container(
                                                width: 100,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    color: disLiked
                                                        ? Colors.red[300]
                                                        : Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        width: 2,
                                                        color: Colors.black)),
                                                child: GestureDetector(
                                                  onDoubleTap: postdislike,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Icon(
                                                          Icons.thumb_down_alt),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 10),
                                                        child: Text("싫어요  " +
                                                            dislikeCount
                                                                .toString()),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                      Divider(
                                        height: 50,
                                        thickness: 1,
                                        color: blackcontroller.blackmode
                                            ? Colors.white
                                            : Colors.black,
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
