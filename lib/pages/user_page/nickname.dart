import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/pages/bulletin_pages/chatbox.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:neologism/pages/user_page/profile.dart';

TextEditingController _nicknameController = TextEditingController();

class UpdateNickname extends StatefulWidget {
  const UpdateNickname({super.key});

  @override
  State<UpdateNickname> createState() => _UpdateNicknameState();
}

class _UpdateNicknameState extends State<UpdateNickname> {
  nicknameUpdate() {
    final _auth = FirebaseAuth.instance.currentUser!;
    _auth.updateDisplayName(_nicknameController.text);
    _auth.reload();
  }

  @override
  void initState() {
    _nicknameController.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _formkey = GlobalKey<FormState>();
    final blackmode = Get.find<BlackModeController>().blackmode;
    final userid = FirebaseAuth.instance.currentUser!.uid;
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text(
            "닉네임 수정",
            style: TextStyle(
                color: blackmode ? Colors.white : blackmodecolor,
                fontWeight: FontWeight.bold),
          ),
          leading: const SizedBox(),
          backgroundColor: blackmode ? blackmodecolor : notblackmodecolor,
          elevation: 0.0,
        ),
        body: Container(
          color: blackmode ? blackmodecolor : notblackmodecolor,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "원하는 닉네임을 입력해주세요!",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: blackmode ? Colors.white : blackmodecolor),
              ),
              const SizedBox(
                height: 40,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "-  이건 지켜주세요!",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: blackmode ? Colors.white : blackmodecolor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "1. 닉네임은 두 글자 이상으로 해주세요.",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: blackmode ? Colors.white : blackmodecolor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "2. 특수문자는 사용할 수 없습니다.",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: blackmode ? Colors.white : blackmodecolor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "3. 띄어쓰기를 사용할 수 없습니다.",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: blackmode ? Colors.white : blackmodecolor),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
              Column(
                children: [
                  Form(
                    key: _formkey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          style: TextStyle(
                              color: blackmode ? Colors.white : Colors.black),
                          onSaved: (value) {
                            _nicknameController.text = value as String;
                          },
                          validator: (value) {
                            if (value == null) {
                              return "닉네임을 입력해주세요.";
                            }
                            if (value.length < 2) {
                              return "두 글자 이상 입력해주세요.";
                            }
                            if (value.contains(RegExp(r'\s'))) {
                              return "공백을 제거해주세요.";
                            }
                            if (value.contains(RegExp(r"[ㄱ-ㅎㅏ-ㅣ]"))) {
                              return "유효한 닉네임을 입력해주세요.";
                            }
                            if (value.contains(RegExp("씨발"))) {
                              return "비속어를 사용할 수 없습니다.";
                            }
                            if (value.contains(
                                RegExp(r'[!@#$%^&*(),.?":{}|<>_-]'))) {
                              return "닉네임에 특수문자를 넣을수 없습니다.";
                            }
                          },
                          controller: _nicknameController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: blackmode
                                        ? Colors.white
                                        : blackmodecolor)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.blue)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: blackmode
                                        ? Colors.white
                                        : blackmodecolor)),
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 90,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "취소",
                              style: TextStyle(fontSize: 20),
                            )),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 90,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: TextButton(
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                _formkey.currentState!.save();
                                nicknameUpdate();
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return UserProfile(
                                    name: _nicknameController.text,
                                    userid: userid,
                                  );
                                }));
                              }
                            },
                            child: Text(
                              "확인",
                              style: TextStyle(fontSize: 20),
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ],
          )),
        ),
      ),
    );
  }
}
