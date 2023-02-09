import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/neo_function/bulletin_func.dart';
import 'package:neologism/neo_function/quiz_func.dart';
import 'package:neologism/pages/bulletin_pages/bulletin_board.dart';
import 'package:neologism/pages/bulletin_pages/post_page.dart';
import 'package:neologism/pages/startpage.dart';

class BulletinCreate extends StatelessWidget {
  const BulletinCreate({super.key, this.index});

  final index;

  @override
  Widget build(BuildContext context) {
    TextEditingController _titleController = TextEditingController();
    TextEditingController _contentController = TextEditingController();

    makepost(context) {
      FirebaseFirestore.instance.collection('post').add({
        "name": _titleController.text,
        "content": _contentController.text,
        "time": Timestamp.now(),
        "like": 0,
        "dislike": 0,
        "chats": []
      });

      Navigator.pushNamed(context, '/bulletin');
    }

    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            "글쓰기",
            style: TextStyle(
              color: Get.find<BlackModeController>().blackmode
                  ? Colors.white
                  : blackmodecolor,
            ),
          ),
          backgroundColor: Get.find<BlackModeController>().blackmode
              ? blackmodecolor
              : notblackmodecolor,
        ),
        body: Container(
          color: Get.find<BlackModeController>().blackmode
              ? blackmodecolor
              : notblackmodecolor,
          padding: const EdgeInsets.only(top: 10),
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: TextField(
                      controller: _titleController,
                      onSubmitted: (value) {
                        _titleController.text = value;
                      },
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[300],
                          hintText: "제목을 입력하세요!",
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey)),
                          border: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey))),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.only(bottom: 40),
                    child: TextFormField(
                      controller: _contentController,
                      onFieldSubmitted: (value) {
                        _contentController.text = value;
                      },
                      decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey)),
                          border: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey)),
                          contentPadding:
                              const EdgeInsets.fromLTRB(20, 0, 0, 80),
                          hintText: "내용을 입력하세요",
                          filled: true,
                          fillColor: Colors.grey[300]),
                      keyboardType: TextInputType.multiline,
                      maxLines: 15,
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      makepost(context);
                    },
                    child: Text(
                      "확인",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(backgroundColor: Colors.blue))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
