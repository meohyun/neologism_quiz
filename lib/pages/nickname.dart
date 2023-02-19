import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neologism/pages/startpage.dart';

TextEditingController _nicknameController = TextEditingController();

class UpdateNickname extends StatefulWidget {
  const UpdateNickname({super.key, this.docid});

  final docid;

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

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        backgroundColor: Colors.purple[100],
        elevation: 0.0,
      ),
      body: Container(
        color: Colors.purple[100],
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "원하는 닉네임을 입력해주세요!",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "1. 닉네임은 두 글자 이상으로 해주세요.",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                const Text(
                  "2. 특수문자는 사용할 수 없습니다.",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                const Text(
                  "3. 띄어쓰기를 사용할 수 없습니다.",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
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
                          if (value
                              .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>_-]'))) {
                            return "닉네임에 특수문자를 넣을수 없습니다.";
                          }
                        },
                        controller: _nicknameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1)),
                        )),
                  ),
                ),
                SizedBox(
                  height: 20,
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
                                return const ScreenPage();
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
    );
  }
}
