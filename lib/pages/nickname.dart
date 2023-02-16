import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neologism/pages/startpage.dart';

TextEditingController _nicknameController = TextEditingController();

class CreateNickname extends StatefulWidget {
  const CreateNickname({super.key, this.docid, this.nickname});

  final docid;
  final nickname;

  @override
  State<CreateNickname> createState() => _CreateNicknameState();
}

class _CreateNicknameState extends State<CreateNickname> {
  nicknameCreate() {
    final userid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('user')
        .doc(widget.docid)
        .update({'user.$userid': _nicknameController.text});
  }

  @override
  void initState() {
    _nicknameController.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[100],
        elevation: 0.0,
      ),
      body: Container(
        color: Colors.purple[100],
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "신조어 퀴즈에 오신걸 환영합니다!",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Text(
              "닉네임을 생성해주세요!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  onSubmitted: (value) {
                    _nicknameController.text = value;
                    nicknameCreate();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ScreenPage(
                        nickname: widget.nickname,
                      );
                    }));
                  },
                  controller: _nicknameController,
                  decoration: const InputDecoration(
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 1)),
                  )),
            ),
          ],
        )),
      ),
    );
  }
}
