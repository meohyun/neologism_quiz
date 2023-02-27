import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:neologism/pages/user_page/profile.dart';

File? pickedFile;
ImagePicker imagePicker = ImagePicker();
TextEditingController _nicknameController = TextEditingController();

class UpdateNickname extends StatefulWidget {
  const UpdateNickname({super.key});

  @override
  State<UpdateNickname> createState() => _UpdateNicknameState();
}

class _UpdateNicknameState extends State<UpdateNickname> {
  final _formkey = GlobalKey<FormState>();
  getnickname() async {
    final useruid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('user')
        .doc('userdatabase')
        .get()
        .then((value) {
      final datas = value.data();
      _nicknameController.text = datas![useruid]['user'];
    });
  }

  nicknameUpdate() async {
    final user = FirebaseAuth.instance.currentUser!;
    user.updateDisplayName(_nicknameController.text);
    user.reload();

    FirebaseFirestore.instance
        .collection('user')
        .doc('userdatabase')
        .update({'${user.uid}.user': _nicknameController.text});
  }

  @override
  void initState() {
    getnickname();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final blackmode = Get.find<BlackModeController>().blackmode;
    final userid = FirebaseAuth.instance.currentUser!.uid;
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "프로필 수정",
              style: TextStyle(
                  color: blackmode ? Colors.white : blackmodecolor,
                  fontWeight: FontWeight.bold),
            ),
            leading: const SizedBox(),
            backgroundColor: blackmode ? blackmodecolor : notblackmodecolor,
            elevation: 0.0,
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            color: blackmode ? blackmodecolor : notblackmodecolor,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.grey[400],
                        context: context,
                        builder: (context) => bottomsheet(context));
                  },
                  child: Obx(
                    () => CircleAvatar(
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                              child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    CupertinoIcons.add,
                                    size: 20,
                                  )),
                            ),
                          )
                        ],
                      ),
                      backgroundImage:
                          profileimagecontroller.isProfilePath.value == true
                              ? FileImage(File(
                                      profileimagecontroller.profilePath.value))
                                  as ImageProvider
                              : const AssetImage(
                                  "assets/user_image.png",
                                ),
                      radius: 35,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Form(
                      key: _formkey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 50,
                          child: TextFormField(
                              style: TextStyle(
                                  color:
                                      blackmode ? Colors.white : Colors.black),
                              onSaved: (value) {
                                setState(() {
                                  _nicknameController.text = value as String;
                                });
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
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.blue)),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: blackmode
                                            ? Colors.white
                                            : blackmodecolor)),
                              )),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "※ 유의사항",
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
                    const SizedBox(
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
                                Get.back();
                              },
                              child: const Text(
                                "취소",
                                style: TextStyle(fontSize: 20),
                              )),
                        ),
                        const SizedBox(
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
                              child: const Text(
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
      ),
    );
  }
}

Widget bottomsheet(BuildContext context) {
  Size size = MediaQuery.of(context).size;

  return Container(
    width: double.infinity,
    height: size.height * 0.2,
    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
    child: Column(
      children: [
        const Text(
          "프로필 사진 선택",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                takePhoto(ImageSource.gallery);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.image,
                    size: 50,
                  ),
                  Text(
                    "앨범에서 찾기",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 80,
            ),
            InkWell(
              onTap: () {
                takePhoto(ImageSource.camera);
              },
              child: Column(
                children: const [
                  Icon(
                    Icons.camera_enhance,
                    size: 50,
                  ),
                  Text(
                    "사진 찍기",
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            )
          ],
        )
      ],
    ),
  );
}

void takePhoto(ImageSource source) async {
  final pickedimage =
      await imagePicker.pickImage(source: source, imageQuality: 100);

  pickedFile = File(pickedimage!.path);
  profileimagecontroller.setProfileImagePath(pickedFile!.path);

  Get.back();
}
