import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/getx/chatmodify.dart';
import 'package:neologism/getx/profileimage.dart';
import 'package:neologism/neo_function/bulletin_func.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:neologism/pages/user_page/profile.dart';

TextEditingController chatController = TextEditingController();
TextEditingController updateChatController = TextEditingController();
final user = FirebaseAuth.instance.currentUser!.displayName;
final userid = FirebaseAuth.instance.currentUser!.uid;
int pressedAttentionIndex = 0;

class ChatContainer extends StatefulWidget {
  const ChatContainer({
    super.key,
    this.docId,
    this.chats,
    this.username,
  });

  final docId;
  final chats;
  final username;

  @override
  State<ChatContainer> createState() => _ChatContainerState();
}

class _ChatContainerState extends State<ChatContainer> {
  addchat() async {
    List<dynamic> chat = [
      {
        "content": chatController.text,
        "time": Timestamp.now(),
        "user": userid,
        "nickname": widget.username,
        "imagepath": profileimagecontroller.profilePath.value,
        "hasimage": profileimagecontroller.isProfilePath.value
      },
    ];
    await FirebaseFirestore.instance
        .collection('post')
        .doc(widget.docId)
        .update({"chats": FieldValue.arrayUnion(chat)});
  }

  @override
  Widget build(BuildContext context) {
    Get.put(chatcontroller());
    Get.put(ProfileImageController());
    final blackmode = Get.find<BlackModeController>().blackmode;
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            return Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                children: [
                  CircleAvatar(
                      backgroundImage:
                          profileimagecontroller.isProfilePath.value == true
                              ? NetworkImage(
                                      profileimagecontroller.profilePath.value)
                                  as ImageProvider
                              : const AssetImage('assets/userimage3.png')),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.username.toString(),
                    style: TextStyle(
                        fontSize: 16,
                        color: blackmode ? Colors.white : blackmodecolor),
                  )
                ],
              ),
            );
          }),
          const SizedBox(
            height: 10,
          ),
          Obx(() {
            return SizedBox(
              height: 60,
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
            docid: widget.docId,
            chats: widget.chats,
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
        "imagepath": profileimagecontroller.profilePath.value,
        "hasimage": profileimagecontroller.isProfilePath.value,
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
        "imagepath": profileimagecontroller.profilePath.value,
        "hasimage": profileimagecontroller.isProfilePath.value,
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
    Get.put(ProfileImageController());
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
              Row(
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  Obx(
                    () => CircleAvatar(
                      backgroundImage:
                          profileimagecontroller.isProfilePath.value == true
                              ? NetworkImage(
                                      profileimagecontroller.profilePath.value)
                                  as ImageProvider
                              : const AssetImage(
                                  "assets/userimage3.png",
                                ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.docs['chats'][pressedAttentionIndex]["nickname"],
                    style: TextStyle(
                        fontSize: 16,
                        color: blackmode ? Colors.white : blackmodecolor),
                  ),
                ],
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
  const ChatBox({super.key, this.docid, this.chats});

  final docid;
  final chats;

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  @override
  void initState() {
    super.initState();
  }
  String userintro = "";
  Future<void> deletechat(docs) async {
    List<dynamic> chat = [
      {
        "content": docs['chats'][pressedAttentionIndex]["content"],
        "time": docs['chats'][pressedAttentionIndex]["time"],
        "user": userid,
        "nickname": docs['chats'][pressedAttentionIndex]["nickname"],
        "imagepath": profileimagecontroller.profilePath.value,
        "hasimage": profileimagecontroller.isProfilePath.value,
      },
    ];

    await FirebaseFirestore.instance
        .collection("post")
        .doc(widget.docid)
        .update({"chats": FieldValue.arrayRemove(chat)});
  }

  getuserprofile(docs) async{
    await FirebaseFirestore.instance.collection('user').doc('userdatabase').get().then((value){
      final datas = value.data();

       userintro = datas![docs['chats'][pressedAttentionIndex]['user']]['intro'];
    });
    print(userintro);
  }

  @override
  Widget build(BuildContext context) {
    Get.put(chatcontroller());
    Get.put(BlackModeController());
    final blackmode = Get.find<BlackModeController>().blackmode;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('post')
            .doc(widget.docid)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            final docs = snapshot.data!;
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                itemCount: docs['chats'].length,
                itemBuilder: (context, index) {
                  final timestamp = docs['chats'][index]['time'];
                  DateTime dt = timestamp.toDate();
                  final mytime = DateFormat('MM/dd HH:mm').format(dt);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        height: 45,
                        thickness: 1.5,
                        color: blackmode ? Colors.white : Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
                        child: Obx(() {
                          return Get.find<chatcontroller>()
                                      .chatmodified
                                      .value &&
                                  pressedAttentionIndex == index
                              ? ChatUpdateBox(
                                  docid: widget.docid,
                                  docs: docs,
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundImage: docs['chats'][index]
                                                      ['hasimage'] ==
                                                  true
                                              ? NetworkImage(docs['chats']
                                                      [index]['imagepath'])
                                                  as ImageProvider
                                              : const AssetImage(
                                                  "assets/userimage3.png",
                                                ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            getuserprofile(docs);

                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return UserProfile(
                                                name: docs['chats'][index]
                                                    ['nickname'],
                                                userid: docs['chats'][index]
                                                    ['user'],
                                                imagepath: docs['chats'][index]
                                                    ['imagepath'],
                                                hasimage: docs['chats'][index]
                                                    ['hasimage'],
                                                intro: userintro,
                                                
                                              );
                                            }));
                                          },
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: Text(
                                              docs['chats'][index]['nickname']
                                                  .toString(),
                                              style: TextStyle(
                                                  color: blackmode
                                                      ? Colors.white
                                                      : blackmodecolor,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          docs['chats'][index]["content"]
                                              .toString(),
                                          style: TextStyle(
                                              color: blackmode
                                                  ? Colors.white
                                                  : blackmodecolor,
                                              fontSize: 18),
                                        ),
                                        Get.find<chatcontroller>()
                                                    .chatmodified
                                                    .value ==
                                                false
                                            ? (userid ==
                                                    docs['chats'][index]["user"]
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
                                                                .text = docs[
                                                                        'chats']
                                                                    [
                                                                    pressedAttentionIndex]
                                                                ["content"];

                                                            Get.find<
                                                                    chatcontroller>()
                                                                .chatmodify();
                                                          },
                                                          child: Text(
                                                            "수정",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue),
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
                                                                  docs);
                                                            },
                                                            child: Text("삭제",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue)))
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox())
                                            : SizedBox()
                                      ],
                                    ),
                                    SizedBox(
                                      height: 18,
                                    ),
                                    Text(
                                      mytime.toString(),
                                      style: TextStyle(
                                          color: blackmode
                                              ? Colors.white
                                              : blackmodecolor),
                                    ),
                                  ],
                                );
                        }),
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
