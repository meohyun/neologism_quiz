import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/neo_function/bulletin_func.dart';
import 'package:neologism/pages/startpage.dart';

TextEditingController _titleController = TextEditingController();
TextEditingController _contentController = TextEditingController();

class BulletinCreate extends StatefulWidget {
  const BulletinCreate({super.key, this.index});

  final index;

  @override
  State<BulletinCreate> createState() => _BulletinCreateState();
}

class _BulletinCreateState extends State<BulletinCreate> {
  final _titleformkey = GlobalKey<FormState>();
  final _contentformkey = GlobalKey<FormState>();

  makepost(context) {
    final user = FirebaseAuth.instance.currentUser!;
    final userid = user.uid;
    FirebaseFirestore.instance.collection('post').add({
      "admin": {"userid": userid, "usernickname": user.displayName},
      "name": _titleController.text,
      "content": _contentController.text,
      "time": Timestamp.now(),
      "like": 0,
      "dislike": 0,
      "chats": [],
      "likes": {'$userid': false},
      'dislikes': {'$userid': false}
    });

    Navigator.pushNamed(context, '/bulletin');
  }

  @override
  void initState() {
    super.initState();
    _titleController.text = "";
    _contentController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
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
                        child: Form(
                          key: _titleformkey,
                          child: TextFormField(
                            controller: _titleController,
                            onSaved: (value) {
                              _titleController.text = value as String;
                            },
                            validator: (value) {
                              if (value == null) {
                                return "제목을 입력해주세요.";
                              }
                              if (value.contains(RegExp("씨발"))) {
                                return "비속어를 사용할 수 없습니다.";
                              }
                            },
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[300],
                                hintText: "제목을 입력하세요!",
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.grey)),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.grey))),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.only(bottom: 40),
                        child: Form(
                          key: _contentformkey,
                          child: TextFormField(
                            controller: _contentController,
                            onSaved: (value) {
                              _contentController.text = value as String;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "내용을 입력해주세요.";
                              }
                            },
                            decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.grey)),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.grey)),
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
                    ),
                    TextButton(
                        onPressed: () {
                          if (_contentformkey.currentState!.validate() &&
                              _titleformkey.currentState!.validate()) {
                            makepost(context);
                          }
                        },
                        child: Text(
                          "확인",
                          style: TextStyle(color: Colors.white),
                        ),
                        style:
                            TextButton.styleFrom(backgroundColor: Colors.blue))
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

class BulletinUpdate extends StatefulWidget {
  const BulletinUpdate({super.key, this.title, this.content, this.docId});

  final title;
  final content;
  final docId;

  @override
  State<BulletinUpdate> createState() => _BulletinUpdateState();
}

class _BulletinUpdateState extends State<BulletinUpdate> {
  @override
  void initState() {
    super.initState();
    _titleController.text = widget.title;
    _contentController.text = widget.content;
  }

  Future<void> updatepost() async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('post').doc(widget.docId);

    await documentReference.update({
      "name": _titleController.text,
      "content": _contentController.text,
      'time': Timestamp.now(),
    });

    Navigator.pushNamed(context, '/bulletin');
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              centerTitle: false,
              title: Text(
                "수정하기",
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
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.grey))),
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
                          updatepost();
                        },
                        child: Text(
                          "확인",
                          style: TextStyle(color: Colors.white),
                        ),
                        style:
                            TextButton.styleFrom(backgroundColor: Colors.blue))
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

class BulletinUpdateIcon extends StatefulWidget {
  const BulletinUpdateIcon({super.key, this.name, this.content, this.docId});

  final name;
  final content;
  final docId;

  @override
  State<BulletinUpdateIcon> createState() => _BulletinUpdateIconState();
}

class _BulletinUpdateIconState extends State<BulletinUpdateIcon> {
  @override
  Widget build(BuildContext context) {
    final blackcontroller = Get.find<BlackModeController>();
    return IconButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: ((context) {
          return BulletinUpdate(
            title: widget.name,
            content: widget.content,
            docId: widget.docId,
          );
        })));
      },
      icon: Icon(CupertinoIcons.pen),
      iconSize: 30,
      color: blackcontroller.blackmode ? Colors.white : blackmodecolor,
    );
  }
}

class BulletinDeleteIcon extends StatefulWidget {
  const BulletinDeleteIcon({super.key, this.docId});

  final docId;

  @override
  State<BulletinDeleteIcon> createState() => _BulletinDeleteState();
}

class _BulletinDeleteState extends State<BulletinDeleteIcon> {
  Future<void> deletepost() async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('post').doc(widget.docId);

    await documentReference.delete();
  }

  @override
  Widget build(BuildContext context) {
    final blackcontroller = Get.find<BlackModeController>();
    return IconButton(
        onPressed: () {
          deleteDialog(context, deletepost);
        },
        icon: Icon(CupertinoIcons.delete,
            color: blackcontroller.blackmode ? Colors.white : blackmodecolor));
  }
}
