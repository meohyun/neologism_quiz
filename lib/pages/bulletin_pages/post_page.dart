import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/getx/chatmodify.dart';
import 'package:neologism/getx/profileimage.dart';
import 'package:neologism/pages/bulletin_pages/postCRUD.dart';
import 'package:neologism/pages/bulletin_pages/chatbox.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:neologism/pages/user_page/profile.dart';

final userid = FirebaseAuth.instance.currentUser!.uid;
bool isLiked = false;
int likeCount = 0;
int dislikeCount = 0;
bool disLiked = false;
String adminprofileimage = "";
String adminintro = "";
bool adminhasimage = false;

class BulletinPost extends StatefulWidget {
  const BulletinPost({
    super.key,
    this.name,
    this.content,
    this.datetime,
    this.like,
    this.dislike,
    this.admin,
    this.adminid,
    this.chats,
    this.docId,
    this.userlike,
    this.userdislike,
  });

  final name;
  final content;
  final datetime;
  final like;
  final dislike;
  final admin;
  final adminid;
  final chats;
  final docId;
  final userlike;
  final userdislike;

  @override
  State<BulletinPost> createState() => _BulletinPostState();
}

class _BulletinPostState extends State<BulletinPost> {
  TextEditingController chatController = TextEditingController();

  final userid = FirebaseAuth.instance.currentUser!.uid;
  final username = FirebaseAuth.instance.currentUser!.displayName;

  adminprofile() {
    FirebaseFirestore.instance
        .collection('user')
        .doc('userdatabase')
        .get()
        .then((value) {
      final data = value.data();

      setState(() {
        adminprofileimage = data![widget.adminid]['imagepath'];
        adminintro = data[widget.adminid]['intro'];
        adminhasimage = data[widget.adminid]['hasimage'];
      });
    });
  }

  updateChatUser() async {
    FirebaseFirestore.instance
        .collection('post')
        .doc(widget.docId)
        .get()
        .then((val) {
      final datas = val.data();
      for (int i = 0; i < datas!["chats"].length; i++) {
        FirebaseFirestore.instance
            .collection('user')
            .doc('userdatabase')
            .get()
            .then((value) {
          final userdata = value.data();
          if (datas["chats"][i]["nickname"] !=
                  userdata![datas["chats"][i]["user"]]["user"] ||
              datas["chats"][i]["imagepath"] !=
                  userdata[datas["chats"][i]["user"]]["imagepath"]) {
            List<dynamic> exchat = [
              {
                "content": datas["chats"][i]["content"],
                "time": datas["chats"][i]["time"],
                "user": datas["chats"][i]["user"],
                "nickname": datas["chats"][i]["nickname"],
                "imagepath": datas["chats"][i]["imagepath"],
                "hasimage": datas["chats"][i]["hasimage"],
              },
            ];
            FirebaseFirestore.instance
                .collection('post')
                .doc(widget.docId)
                .update({"chats": FieldValue.arrayRemove(exchat)});
          }
          List<dynamic> chat = [
            {
              "content": datas["chats"][i]["content"],
              "time": datas["chats"][i]["time"],
              "user": datas["chats"][i]["user"],
              "nickname": userdata[datas["chats"][i]["user"]]["user"],
              "imagepath": userdata[datas["chats"][i]["user"]]["imagepath"],
              "hasimage": userdata[datas["chats"][i]["user"]]["hasimage"],
            },
          ];
          FirebaseFirestore.instance
              .collection('post')
              .doc(widget.docId)
              .update({"chats": FieldValue.arrayUnion(chat)});
        });
      }
    });
  }

  @override
  void initState() {
    adminprofile();
    updateChatUser();
    Get.put(chatcontroller());
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        likeCount = widget.like;
        isLiked = widget.userlike;
        disLiked = widget.userdislike;
        dislikeCount = widget.dislike;
      });
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
    Get.put(ProfileImageController());
    final blackcontroller = Get.find<BlackModeController>();
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            backgroundColor:
                blackcontroller.blackmode ? blackmodecolor : notblackmodecolor,
            appBar: AppBar(
              centerTitle: false,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back)),
              title: Text("게시판",
                  style: TextStyle(
                    color: blackcontroller.blackmode
                        ? Colors.white
                        : blackmodecolor,
                  )),
              elevation: 0.0,
              backgroundColor: blackcontroller.blackmode
                  ? blackmodecolor
                  : notblackmodecolor,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height: 120,
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
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Get.to(() => UserProfile(
                                                          name: widget.admin,
                                                          userid:
                                                              widget.adminid,
                                                          hasimage:
                                                              adminhasimage,
                                                          imagepath:
                                                              adminprofileimage,
                                                          intro: adminintro,
                                                        ));
                                                  },
                                                  child: CircleAvatar(
                                                      backgroundImage: adminhasimage ==
                                                              true
                                                          ? NetworkImage(
                                                                  adminprofileimage)
                                                              as ImageProvider
                                                          : const AssetImage(
                                                              'assets/userimage3.png')),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Get.to(() => UserProfile(
                                                          name: widget.admin,
                                                          userid:
                                                              widget.adminid,
                                                          hasimage:
                                                              adminhasimage,
                                                          imagepath:
                                                              adminprofileimage,
                                                          intro: adminintro,
                                                        ));
                                                  },
                                                  child: Text(
                                                    widget.admin.toString(),
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: blackcontroller
                                                                .blackmode
                                                            ? Colors.white
                                                            : blackmodecolor),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              widget.datetime.toString(),
                                              style: TextStyle(
                                                  color:
                                                      blackcontroller.blackmode
                                                          ? Colors.white
                                                          : blackmodecolor),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Text(widget.name,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      blackcontroller.blackmode
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
                                                            BorderRadius
                                                                .circular(10),
                                                        color: isLiked
                                                            ? Colors.blue[300]
                                                            : Colors.white,
                                                        border: Border.all(
                                                            width: 2,
                                                            color:
                                                                Colors.black)),
                                                    child: GestureDetector(
                                                      onDoubleTap: postlike,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Icon(Icons
                                                              .thumb_up_alt),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10),
                                                            child: Text(
                                                                "좋아요 ${likeCount.toString()} "),
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
                                                        const Icon(Icons
                                                            .thumb_down_alt),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10),
                                                          child: Text(
                                                              "싫어요  ${dislikeCount.toString()}"),
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
                                          chats: widget.chats,
                                          username: username,
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
      ),
    );
  }
}
