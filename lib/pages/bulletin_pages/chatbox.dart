import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/getx/chatmodify.dart';
import 'package:neologism/neo_function/bulletin_func.dart';
import 'package:neologism/neo_function/quiz_func.dart';
import 'package:neologism/pages/startpage.dart';

TextEditingController chatController = TextEditingController();
TextEditingController updateChatController = TextEditingController();
final user = FirebaseAuth.instance.currentUser!.displayName;
final userid = FirebaseAuth.instance.currentUser!.uid;
int pressedAttentionIndex = 0;

class ChatContainer extends StatefulWidget {
  const ChatContainer({super.key, this.docId, this.userdocid});

  final docId;
  final userdocid;

  @override
  State<ChatContainer> createState() => _ChatContainerState();
}

class _ChatContainerState extends State<ChatContainer> {
  final _chatkey = GlobalKey<FormState>();

  addchat() {
    List<dynamic> chat = [
      {
        "content": chatController.text,
        "time": Timestamp.now(),
        "user": userid,
        "nickname": user
      },
    ];
    FirebaseFirestore.instance
        .collection('post')
        .doc(widget.docId)
        .update({"chats": FieldValue.arrayUnion(chat)});
  }

  @override
  Widget build(BuildContext context) {
    Get.put(chatcontroller());
    final blackmode = Get.find<BlackModeController>().blackmode;
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: TextFormField(
                style:
                    TextStyle(color: blackmode ? Colors.white : Colors.black),
                enabled: Get.find<chatcontroller>().chatmodified.value == false
                    ? true
                    : false,
                controller: chatController,
                decoration: InputDecoration(
                    hintText:
                        Get.find<chatcontroller>().chatmodified.value == false
                            ? "댓글을 남겨보세요."
                            : "",
                    hintStyle: TextStyle(
                        color: blackmode ? Colors.white : Colors.black),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: blackmode ? Colors.white : Colors.black)),
                    disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: blackmode ? Colors.white : Colors.black)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: blackmode ? Colors.white : Colors.black)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: blackmode ? Colors.white : Colors.black))),
                onFieldSubmitted: (value) {
                  chatController.text = value;
                  addchat();
                  chatController.text = "";
                },
              ),
            );
          }),
          ChatBox(
            userdocid: widget.userdocid,
            docid: widget.docId,
          )
        ],
      ),
    );
  }
}

class ChatUpdateBox extends StatefulWidget {
  const ChatUpdateBox({super.key, this.docid, this.docs});

  final docid;
  final docs;

  @override
  State<ChatUpdateBox> createState() => _ChatUpdateBoxState();
}

class _ChatUpdateBoxState extends State<ChatUpdateBox> {
  final _updatekey = GlobalKey<FormState>();

  updatechat(docs) async {
    List<dynamic> exchat = [
      {
        "content": docs['chats'][pressedAttentionIndex]["content"],
        "time": docs['chats'][pressedAttentionIndex]["time"],
        "user": userid,
        "nickname": docs['chats'][pressedAttentionIndex]["nickname"],
      },
    ];

    await FirebaseFirestore.instance
        .collection("post")
        .doc(widget.docid)
        .update({"chats": FieldValue.arrayRemove(exchat)});

    List<dynamic> chat = [
      {
        "content": updateChatController.text,
        "time": Timestamp.now(),
        "user": userid,
        "nickname": docs['chats'][pressedAttentionIndex]["nickname"],
      },
    ];
    await FirebaseFirestore.instance
        .collection('post')
        .doc(widget.docid)
        .update({"chats": FieldValue.arrayUnion(chat)});
  }

  @override
  Widget build(BuildContext context) {
    Get.put(chatcontroller());
    final blackmode = Get.find<BlackModeController>().blackmode;
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    const CircleAvatar(
                      child: Icon(
                        Icons.person,
                      ),
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      user!,
                      style: TextStyle(
                          fontSize: 16,
                          color: blackmode ? Colors.white : blackmodecolor),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_updatekey.currentState!.validate()) {
                        _updatekey.currentState!.save();
                        updatechat(widget.docs);
                        Get.find<chatcontroller>().chatmodify();
                      }
                    },
                    child: Text(
                      "확인",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.find<chatcontroller>().chatmodify();
                    },
                    child: Text(
                      "취소",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            height: 50,
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _updatekey,
              child: TextFormField(
                style:
                    TextStyle(color: blackmode ? Colors.white : Colors.black),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "댓글을 입력해주세요";
                  }
                },
                // when enterkey pressed
                onFieldSubmitted: (value) {
                  updateChatController.text = value as String;
                  if (_updatekey.currentState!.validate()) {
                    updatechat(widget.docs);
                    Get.find<chatcontroller>().chatmodify();
                  }
                },
                // when submit button pressed
                onSaved: (value) {
                  updateChatController.text = value as String;
                },
                controller: updateChatController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: blackmode ? Colors.white : Colors.black)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: blackmode ? Colors.white : Colors.black)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: blackmode ? Colors.white : Colors.black))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBox extends StatefulWidget {
  const ChatBox({super.key, this.docid, this.userdocid});

  final docid;
  final userdocid;

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(chatcontroller());
    Future<void> deletechat(docs) async {
      List<dynamic> chat = [
        {
          "content": docs['chats'][pressedAttentionIndex]["content"],
          "time": docs['chats'][pressedAttentionIndex]["time"],
          "user": userid,
          "nickname": docs['chats'][pressedAttentionIndex]["nickname"],
        },
      ];

      await FirebaseFirestore.instance
          .collection("post")
          .doc(widget.docid)
          .update({"chats": FieldValue.arrayRemove(chat)});
    }

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('post')
            .doc(widget.docid)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            final Docs = snapshot.data!;
            Get.put(BlackModeController());
            final blackmode = Get.find<BlackModeController>().blackmode;
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                itemCount: Docs['chats'].length,
                itemBuilder: (context, index) {
                  final timestamp = Docs['chats'][index]['time'];
                  DateTime dt = timestamp.toDate();
                  final mytime = DateFormat('MM/dd HH:mm').format(dt);
                  return Column(
                    children: [
                      Divider(
                        height: 45,
                        thickness: 1.5,
                        color: blackmode ? Colors.white : Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 100,
                            child: Obx(() {
                              return Get.find<chatcontroller>()
                                          .chatmodified
                                          .value &&
                                      pressedAttentionIndex == index
                                  ? ChatUpdateBox(
                                      docid: widget.docid,
                                      docs: Docs,
                                    )
                                  : ListTile(
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                child: Icon(Icons.person),
                                                backgroundColor: Colors.white60,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                Docs['chats'][index]['nickname']
                                                    .toString(),
                                                style: TextStyle(
                                                    color: blackmode
                                                        ? Colors.white
                                                        : blackmodecolor),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            Docs['chats'][index]["content"]
                                                .toString(),
                                            style: TextStyle(
                                                color: blackmode
                                                    ? Colors.white
                                                    : blackmodecolor),
                                          ),
                                        ],
                                      ),
                                      subtitle: Text(
                                        mytime.toString(),
                                        style: TextStyle(
                                            color: blackmode
                                                ? Colors.white
                                                : blackmodecolor),
                                      ),
                                      trailing: Get.find<chatcontroller>()
                                                  .chatmodified
                                                  .value ==
                                              false
                                          ? (userid ==
                                                  Docs['chats'][index]["user"]
                                              ? SizedBox(
                                                  width: 60,
                                                  child: Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            pressedAttentionIndex =
                                                                index;
                                                          });
                                                          updateChatController
                                                              .text = Docs[
                                                                      'chats'][
                                                                  pressedAttentionIndex]
                                                              ["content"];

                                                          Get.find<
                                                                  chatcontroller>()
                                                              .chatmodify();
                                                          print(Get.find<
                                                                  chatcontroller>()
                                                              .chatmodified);
                                                        },
                                                        child: Text(
                                                          "수정",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              pressedAttentionIndex =
                                                                  index;
                                                            });
                                                            deleteChatDialog(
                                                                context,
                                                                deletechat,
                                                                Docs);
                                                          },
                                                          child: Text("삭제",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue)))
                                                    ],
                                                  ),
                                                )
                                              : null)
                                          : null);
                            })),
                      ),
                    ],
                  );
                },
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
