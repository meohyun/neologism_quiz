import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
TextEditingController _introController = TextEditingController();
String imageUrl = "";

class UpdateNickname extends StatefulWidget {
  const UpdateNickname({super.key, this.intro});

  final intro;

  @override
  State<UpdateNickname> createState() => _UpdateNicknameState();
}

class _UpdateNicknameState extends State<UpdateNickname> {
  final useruid = FirebaseAuth.instance.currentUser!.uid;
  final _formkey = GlobalKey<FormState>();
  final _introformkey = GlobalKey<FormState>();
  List usernicknames = [];

  getprofile() {
    FirebaseFirestore.instance
        .collection('user')
        .doc('userdatabase')
        .get()
        .then((value) {
      final datas = value.data();
      _nicknameController.text = datas![useruid]['user'];
      profileimagecontroller.profilePath.value = datas[useruid]['imagepath'];
      profileimagecontroller.isProfilePath.value = datas[useruid]['hasimage'];

      for (int i = 0; i<datas.length; i++){
        print(datas);
      }
    });
  }

  nicknameUpdate() async {
    final user = FirebaseAuth.instance.currentUser!;
    user.updateDisplayName(_nicknameController.text);
    user.reload();

    FirebaseFirestore.instance.collection('user').doc('userdatabase').update({
      '${user.uid}.user': _nicknameController.text,
      '${user.uid}.intro': _introController.text,
    });
  }

  @override
  void initState() {
    getprofile();
    _introController.text = widget.intro;
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
          resizeToAvoidBottomInset: false,
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
          body: WillPopScope(
            onWillPop: () {
              return Future(() => false);
            },
            child: Container(
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
                          backgroundImage:
                              profileimagecontroller.isProfilePath.value == true
                                  ? NetworkImage(profileimagecontroller
                                      .profilePath.value) as ImageProvider
                                  : const AssetImage(
                                      "assets/userimage3.png",
                                    ),
                          radius: 35,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 20, 0, 0),
                                  child: CircleAvatar(
                                      radius: 14,
                                      backgroundColor: Colors.grey[300],
                                      child: const Icon(
                                        CupertinoIcons.add,
                                        size: 20,
                                      )),
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 42),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "닉네임",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: blackmode
                                      ? Colors.white
                                      : blackmodecolor),
                            ),
                          ],
                        ),
                      ),
                      Form(
                        key: _formkey,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 50,
                            child: TextFormField(
                                style: TextStyle(
                                    color: blackmode
                                        ? Colors.white
                                        : Colors.black),
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
                                  focusedBorder: const OutlineInputBorder(
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
                      Padding(
                        padding: const EdgeInsets.only(left: 18),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "자기소개",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: blackmode
                                      ? Colors.white
                                      : blackmodecolor),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Form(
                            key: _introformkey,
                            child: TextFormField(
                              style: TextStyle(
                                  color:
                                      blackmode ? Colors.white : Colors.black),
                              controller: _introController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: blackmode
                                              ? Colors.white
                                              : blackmodecolor)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1,
                                          color: blackmode
                                              ? Colors.white
                                              : blackmodecolor)),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.blue))),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "한 글자 이상 입력해주세요!";
                                }
                                if (value.contains(RegExp("씨발"))) {
                                  return "비속어를 사용할 수 없습니다.";
                                }
                                if (value.length > 30) {
                                  return "자기소개는 30자 이하로 작성해주세요.";
                                }
                              },
                              onSaved: (value) {
                                _introController.text = value as String;
                              },
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "※ 유의사항",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    blackmode ? Colors.white : blackmodecolor),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "1. 닉네임은 두 글자 이상으로 해주세요.",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    blackmode ? Colors.white : blackmodecolor),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "2. 특수문자는 사용할 수 없습니다.",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    blackmode ? Colors.white : blackmodecolor),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "3. 띄어쓰기를 사용할 수 없습니다.",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    blackmode ? Colors.white : blackmodecolor),
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
                                  if (_formkey.currentState!.validate() &&
                                      _introformkey.currentState!.validate()) {
                                    _formkey.currentState!.save();
                                    _introformkey.currentState!.save();
                                    nicknameUpdate();
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return UserProfile(
                                        name: _nicknameController.text,
                                        userid: userid,
                                        imagepath: profileimagecontroller
                                            .profilePath.value,
                                        hasimage: profileimagecontroller
                                            .isProfilePath.value,
                                        intro: _introController.text,
                                        route: const Startpage(),
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
      ),
    );
  }
}

Widget bottomsheet(BuildContext context) {
  Size size = MediaQuery.of(context).size;

  return Container(
    width: double.infinity,
    height: size.height * 0.2,
    margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
                normalImage();
              },
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    size: 40,
                  ),
                  Text(
                    "기본 이미지로 변경",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 35,
            ),
            InkWell(
              onTap: () {
                takePhoto(ImageSource.gallery);
              },
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image,
                    size: 40,
                  ),
                  Text(
                    "앨범에서 찾기",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 40,
            ),
            InkWell(
              onTap: () {
                takePhoto(ImageSource.camera);
              },
              child: const Column(
                children: [
                  Icon(
                    Icons.camera_enhance,
                    size: 40,
                  ),
                  Text(
                    "사진 찍기",
                    style: TextStyle(fontSize: 15),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        )
      ],
    ),
  );
}

void takePhoto(ImageSource source) async {
  final useruid = FirebaseAuth.instance.currentUser!.uid;
  final pickedimage =
      await imagePicker.pickImage(source: source, imageQuality: 100);

  //upload to firebase storage
  Reference referenceRoot = FirebaseStorage.instance.ref();
  Reference referenceDirImages = referenceRoot.child('image');
  Reference referenceImageToUpload = referenceDirImages.child(useruid);

  try {
    await referenceImageToUpload.putFile(File(pickedimage!.path));
    imageUrl = await referenceImageToUpload.getDownloadURL();
    profileimagecontroller.isProfilePath.value = true;
    profileimagecontroller.setProfileImagePath(imageUrl);
  } catch (error) {
    //some error occurred
  }

  FirebaseFirestore.instance
      .collection('user')
      .doc('userdatabase')
      .update({'$useruid.imagepath': imageUrl, '$useruid.hasimage': true});

  Get.back();
}

void normalImage(){
  final useruid = FirebaseAuth.instance.currentUser!.uid;
  profileimagecontroller.isProfilePath.value = false;
  profileimagecontroller.setProfileImagePath("https://firebasestorage.googleapis.com/v0/b/neologismquiz.appspot.com/o/image%2Fuserimage3.png?alt=media&token=1bca2275-037e-4470-904d-81491727fdbb");
  FirebaseFirestore.instance
      .collection('user')
      .doc('userdatabase')
      .update({'$useruid.imagepath': "https://firebasestorage.googleapis.com/v0/b/neologismquiz.appspot.com/o/image%2Fuserimage3.png?alt=media&token=1bca2275-037e-4470-904d-81491727fdbb", '$useruid.hasimage': false});

  Get.back();
}