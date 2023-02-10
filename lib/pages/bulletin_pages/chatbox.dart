import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

TextEditingController chatController = TextEditingController();
final user = FirebaseAuth.instance.currentUser!.displayName;

class ChatContainer extends StatefulWidget {
  const ChatContainer({super.key, this.docId});

  final docId;

  @override
  State<ChatContainer> createState() => _ChatContainerState();
}

class _ChatContainerState extends State<ChatContainer> {
  addchat() {
    final user = FirebaseAuth.instance.currentUser!.displayName;
    List<dynamic> chat = [
      {user.toString(): chatController.text, "time": Timestamp.now()},
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

class ChatBox extends StatelessWidget {
  const ChatBox({super.key, this.docid});

  final docid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('post')
            .doc(docid)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          final Docs = snapshot.data!;
          return Container(
            height: MediaQuery.of(context).size.height *
                (0.1 * Docs['chats'].length),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: Docs['chats'].length,
              itemBuilder: (context, index) {
                final timestamp = Docs['chats'][index]['time'];
                DateTime dt = timestamp.toDate();
                final mytime = DateFormat('HH:mm').format(dt);
                return Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 50,
                      child: ListTile(
                          title: Text(Docs['chats'][index][user].toString()),
                          subtitle: Row(
                            children: [
                              Text(user.toString()),
                              SizedBox(width: 10),
                              Text(mytime.toString()),
                            ],
                          ),
                          trailing: SizedBox(
                            width: 60,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    print('수정하기');
                                  },
                                  child: Text(
                                    "수정",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                    onTap: () {},
                                    child: Text("삭제",
                                        style: TextStyle(color: Colors.blue)))
                              ],
                            ),
                          )),
                    ),
                    Divider(
                      height: 30,
                      thickness: 1.5,
                    )
                  ],
                );
              },
            ),
          );
        });
  }
}
