import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:neologism/getx/chatmodify.dart';
import 'package:neologism/neo_function/bulletin_func.dart';
import 'package:neologism/neo_function/quiz_func.dart';

TextEditingController chatController = TextEditingController();
TextEditingController modifychatcontroller = TextEditingController();
final user = FirebaseAuth.instance.currentUser!.displayName;
final userid = FirebaseAuth.instance.currentUser!.uid;
int pressedAttentionIndex = 0;

class ChatContainer extends StatefulWidget {
  const ChatContainer({super.key, this.docId});

  final docId;

  @override
  State<ChatContainer> createState() => _ChatContainerState();
}

class _ChatContainerState extends State<ChatContainer> {
  addchat() {
    List<dynamic> chat = [
      {"content": chatController.text, "time": Timestamp.now(), "user": userid},
    ];
    FirebaseFirestore.instance
        .collection('post')
        .doc(widget.docId)
        .update({"chats": FieldValue.arrayUnion(chat)});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "댓글",
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          child: TextField(
            controller: chatController,
            decoration: const InputDecoration(
                hintText: "댓글을 남겨보세요.",
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.grey))),
            onSubmitted: (value) {
              setState(() {
                chatController.text = value;
              });
              addchat();
              chatController.text = "";
            },
          ),
        ),
        ChatBox(
          docid: widget.docId,
        )
      ],
    );
  }
}

class ChatUpdateBox extends StatelessWidget {
  const ChatUpdateBox({super.key, this.docid, this.docs});

  final docid;
  final docs;

  updatechat(docs) async {
    List<dynamic> exchat = [
      {
        "content": docs['chats'][pressedAttentionIndex]["content"],
        "time": docs['chats'][pressedAttentionIndex]["time"],
        "user": userid
      },
    ];

    await FirebaseFirestore.instance
        .collection("post")
        .doc(docid)
        .update({"chats": FieldValue.arrayRemove(exchat)});

    List<dynamic> chat = [
      {
        "content": modifychatcontroller.text,
        "time": Timestamp.now(),
        "user": userid
      },
    ];
    await FirebaseFirestore.instance
        .collection('post')
        .doc(docid)
        .update({"chats": FieldValue.arrayUnion(chat)});
  }

  @override
  Widget build(BuildContext context) {
    Get.put(chatcontroller());
    return Column(
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
                  SizedBox(
                    width: 5,
                  ),
                  CircleAvatar(
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
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
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
        SizedBox(
          height: 10,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          height: 50,
          child: TextField(
            onSubmitted: (value) {
              modifychatcontroller.text = value;
              updatechat(docs);
              Get.find<chatcontroller>().chatmodify();
            },
            controller: modifychatcontroller,
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.grey))),
          ),
        ),
      ],
    );
  }
}

class ChatBox extends StatefulWidget {
  const ChatBox({super.key, this.docid});

  final docid;

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
          "user": userid
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
            return CircularProgressIndicator();
          }
          final Docs = snapshot.data!;

          if (snapshot.hasData) {
            return Container(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
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
                                              Text(user.toString()),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(Docs['chats'][index]["content"]
                                              .toString()),
                                        ],
                                      ),
                                      subtitle: Text(mytime.toString()),
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
                                                          modifychatcontroller
                                                              .text = "";
                                                          setState(() {
                                                            pressedAttentionIndex =
                                                                index;
                                                          });

                                                          Get.find<
                                                                  chatcontroller>()
                                                              .chatmodify();
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
