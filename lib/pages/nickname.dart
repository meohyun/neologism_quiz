import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neologism/pages/startpage.dart';

TextEditingController _nicknameController = TextEditingController();

class UpdateNickname extends StatefulWidget {
  const UpdateNickname({super.key, this.docid, this.nickname});

  final docid;
  final nickname;

  @override
  State<UpdateNickname> createState() => _UpdateNicknameState();
}

class _UpdateNicknameState extends State<UpdateNickname> {
  nicknameUpdate() async {
    final _auth = FirebaseAuth.instance.currentUser!;
    await _auth.updateDisplayName(_nicknameController.text);
    await _auth.reload();
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
            const Text(
              "원하는 닉네임을 입력해주세요!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  onSubmitted: (value) {
                    _nicknameController.text = value;
                    nicknameUpdate();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const ScreenPage();
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
