import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neologism/neo_function/bulletin_func.dart';
import 'package:neologism/neo_function/quiz_func.dart';

TextEditingController chatController = TextEditingController();
final user = FirebaseAuth.instance.currentUser!.displayName;
final userid = FirebaseAuth.instance.currentUser!.uid;

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

class ChatBox extends StatefulWidget {
  const ChatBox({super.key, this.docid});

  final docid;

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  @override
  Widget build(BuildContext context) {
    int pressedAttentionIndex = 0;

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
              height: MediaQuery.of(context).size.height *
                  (0.1 * Docs['chats'].length),
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
                        height: 30,
                        thickness: 1.5,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 50,
                        child: ListTile(
                            title: Text(
                                Docs['chats'][index]["content"].toString()),
                            subtitle: Row(
                              children: [
                                Text(user.toString()),
                                SizedBox(width: 10),
                                Text(mytime.toString()),
                              ],
                            ),
                            trailing: userid == Docs['chats'][index]["user"]
                                ? SizedBox(
                                    width: 60,
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {},
                                          child: Text(
                                            "수정",
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                pressedAttentionIndex = index;
                                              });
                                              deleteChatDialog(
                                                  context, deletechat, Docs);
                                            },
                                            child: Text("삭제",
                                                style: TextStyle(
                                                    color: Colors.blue)))
                                      ],
                                    ),
                                  )
                                : null),
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
