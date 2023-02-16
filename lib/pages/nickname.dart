import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neologism/pages/startpage.dart';

TextEditingController _nicknameController = TextEditingController();

class CreateNickname extends StatefulWidget {
  const CreateNickname({super.key, this.docid});

  final docid;

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
      appBar: AppBar(),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("닉네임을 생성해주세요!"),
          TextField(
              onSubmitted: (value) {
                _nicknameController.text = value;
                nicknameCreate();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ScreenPage();
                }));
              },
              controller: _nicknameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
              ))
        ],
      )),
    );
  }
}
