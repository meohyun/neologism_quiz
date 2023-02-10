import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

TextEditingController chatController = TextEditingController();

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
      {user.toString(): chatController.text}
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
            height: 200,
            child: ListView.builder(
              itemCount: Docs['chats'].length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  child: ListTile(title: Text(Docs['chats'][index].toString())),
                );
              },
            ),
          );
        });
  }
}
