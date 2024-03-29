import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/getx/profileimage.dart';
import 'package:neologism/neo_function/settings.dart';
import 'package:neologism/neo_function/quiz_func.dart';
import 'package:neologism/pages/quiz_page/word_quiz.dart';
import 'package:neologism/pages/user_page/profile.dart';
import 'package:neologism/widgets/bottom_navigation.dart';
import 'package:neologism/widgets/mydrawer.dart';
import 'package:neologism/widgets/records.dart';
import '../neo_function/firebase_message.dart';

var blackmodecolor = Colors.black;
var notblackmodecolor = Colors.deepPurple[100];

class Startpage extends StatefulWidget {
  const Startpage({super.key});

  @override
  State<Startpage> createState() => _StartpageState();
}

class _StartpageState extends State<Startpage> {
  Timer? _timer;
  @override
  void initState() {
    descblocked = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Authentication(),
    );
  }
}

class Authentication extends StatelessWidget {
  const Authentication({super.key});

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              color: Colors.deepPurple[100],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: Text(
                        "Neologism Quiz",
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.tealAccent[700]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: Text(
                        "신조어 퀴즈",
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.tealAccent[700]),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 25),
                      child: Text(
                        "신조어 퀴즈에 오신걸 환영합니다!",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 25),
                      child: Text(
                        "퀴즈를 통해 신조어를 배워봐요!",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 50,
                      width: 300,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.white, width: 0.5),
                                borderRadius: BorderRadius.circular(15.0))),
                        onPressed: () {
                          signInWithGoogle();
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image(
                              image: AssetImage('assets/googlelogo.png'),
                              width: 50,
                              height: 50,
                            ),
                            Text(
                              "구글계정으로 로그인하기",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          return const ScreenPage();
        });
  }
}

class ScreenPage extends StatefulWidget {
  const ScreenPage({super.key});

  @override
  State<ScreenPage> createState() => _ScreenPageState();
}

class _ScreenPageState extends State<ScreenPage> {
  int index = 0;
  bool _isChecked = false;
  String? mtoken = "";
  final useruid = FirebaseAuth.instance.currentUser!.uid;
  final username = FirebaseAuth.instance.currentUser!.displayName;

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print("My token is $mtoken");
      });
      saveToken(token!);
    });
  }

  makeuserprofile() async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc('userdatabase')
        .get()
        .then((value) {
      final userprofile = value.data();

      if (userprofile![useruid] == null) {
        FirebaseFirestore.instance
            .collection('user')
            .doc('userdatabase')
            .update({
          '$useruid.result': [],
          '$useruid.intro': "",
          '$useruid.hasimage': false,
          '$useruid.imagepath':
              "https://firebasestorage.googleapis.com/v0/b/neologismquiz.appspot.com/o/image%2Fuserimage3.png?alt=media&token=1bca2275-037e-4470-904d-81491727fdbb",
          '$useruid.user': username,
        });
      }
    });
  }

  getprofile() {
    final useruid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('user')
        .doc('userdatabase')
        .get()
        .then((value) {
      final data = value.data();
      setState(() {
        profileimagecontroller.profilePath.value = data![useruid]['imagepath'];
        profileimagecontroller.isProfilePath.value = data[useruid]['hasimage'];
        intro = data[useruid]['intro'];
      });
    });
  }

  void settings(context) {
    Get.put(BlackModeController());
    bool _isChecked = Get.find<BlackModeController>().blackmode;
    showDialog(
        context: context,
        builder: (context) {
          return GetBuilder(
            init: BlackModeController(),
            builder: (_) => Dialog(
              backgroundColor: Get.find<BlackModeController>().blackmode
                  ? Colors.black
                  : Colors.white,
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 3,
                      color: Get.find<BlackModeController>().blackmode
                          ? Colors.white
                          : Colors.deepPurple.shade100),
                  borderRadius: const BorderRadius.all(Radius.circular(25))),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 300,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                CupertinoIcons.xmark_circle,
                                color: Get.find<BlackModeController>().blackmode
                                    ? Colors.white
                                    : Colors.black,
                              )),
                          Text("설정",
                              style: TextStyle(
                                  fontSize: 20,
                                  color:
                                      Get.find<BlackModeController>().blackmode
                                          ? Colors.white
                                          : Colors.black)),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                            width: 30,
                          ),
                        Icon(
                          Icons.dark_mode,
                          color: Get.find<BlackModeController>().blackmode
                              ? Colors.white
                              : Colors.black,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          "다크 모드",
                          style: TextStyle(
                              fontSize: 20,
                              color: Get.find<BlackModeController>().blackmode
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Switch.adaptive(
                            value: _isChecked,
                            onChanged: (value) {
                              setState(() {
                                _isChecked = value;
                              });
                              Get.find<BlackModeController>().blackmodechange();
                            })
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.power_settings_new,
                            color: Get.find<BlackModeController>().blackmode
                                ? Colors.white
                                : Colors.black,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            "로그 아웃",
                            style: TextStyle(
                                fontSize: 20,
                                color: Get.find<BlackModeController>().blackmode
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                        ],
                      ),
                      onTap: () {
                        logout(context);
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    requestPermission();
    getToken();
    initInfo(context);
    index = 0;
    makeuserprofile();
    getprofile();
    final _auth = FirebaseAuth.instance.currentUser!;
    _auth.reload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileImageController());
    Get.put(BlackModeController());
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => Scaffold(
          bottomNavigationBar: MyBottomnavigator(
            index: index,
          ),
          backgroundColor: Get.find<BlackModeController>().blackmode
              ? blackmodecolor
              : notblackmodecolor,
          appBar: AppBar(
            iconTheme: IconThemeData(
                color: Get.find<BlackModeController>().blackmode
                    ? Colors.white
                    : blackmodecolor),
            toolbarHeight: 80.0,
            elevation: 0.0,
            centerTitle: true,
            title: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                "신조어 퀴즈",
                style: TextStyle(
                    color: Colors.tealAccent[700],
                    fontSize: 25.0,
                    fontWeight: FontWeight.w700),
              ),
            ),
            backgroundColor: Get.find<BlackModeController>().blackmode == true
                ? blackmodecolor
                : notblackmodecolor,
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 15, 0),
                child: GestureDetector(
                  onTap: () {
                    settings(context);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.settings,
                        color: Get.find<BlackModeController>().blackmode
                            ? Colors.white
                            : Colors.black,
                      ),
                      Text(
                        "설정",
                        style: TextStyle(
                            fontSize: 12,
                            color: Get.find<BlackModeController>().blackmode
                                ? Colors.white
                                : Colors.black),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          body: WillPopScope(
            onWillPop: () => onWillPop(context),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "프로필",
                          style: TextStyle(
                              fontSize: 20,
                              color: Get.find<BlackModeController>().blackmode
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: TextButton(
                              onPressed: () {
                                Get.to(UserProfile(
                                  userid: useruid,
                                  imagepath:
                                      profileimagecontroller.profilePath.value,
                                  hasimage: profileimagecontroller
                                      .isProfilePath.value,
                                  intro: intro,
                                ));
                              },
                              child: const Text(
                                "더 보기",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Get.find<BlackModeController>().blackmode
                                ? Colors.black
                                : Colors.deepPurple[50],
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(width: 2, color: Colors.white)),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.12,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 2)),
                                child: CircleAvatar(
                                  backgroundImage: profileimagecontroller
                                              .isProfilePath.value ==
                                          true
                                      ? NetworkImage(profileimagecontroller
                                          .profilePath.value) as ImageProvider
                                      : const AssetImage(
                                          "assets/userimage3.png",
                                        ),
                                  radius: 25,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      username.toString(),
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Get.find<BlackModeController>()
                                                  .blackmode
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                    const SizedBox(height: 5,),
                                    Opacity(
                                      opacity: 0.5,
                                      child: Row(
                                        children: [
                                          Text(
                                            intro.toString(),
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Get.find<BlackModeController>()
                                                        .blackmode
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 10, 0, 10),
                        child: Text(
                          "최근 기록",
                          style: TextStyle(
                              fontSize: 20,
                              color: Get.find<BlackModeController>().blackmode
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border:
                                    Border.all(width: 2, color: Colors.white),
                                color: Get.find<BlackModeController>().blackmode
                                    ? Colors.black
                                    : Colors.deepPurple[50]),
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GameRecord(
                                userid: useruid,
                              ),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
