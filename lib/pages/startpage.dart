import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/neo_function/quiz_func.dart';
import 'package:neologism/pages/bulletin_pages/bulletin_board.dart';
import 'package:neologism/pages/dictionary_page/dict_neologism.dart';
import 'package:neologism/widgets/Buttons.dart';
import 'package:neologism/widgets/mydrawer.dart';

var blackmodecolor = Colors.black;
var notblackmodecolor = Colors.deepPurple[100];

class Startpage extends StatefulWidget {
  @override
  State<Startpage> createState() => _StartpageState();
}

class _StartpageState extends State<Startpage> {
  Timer? _timer;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: Text(
                      "신조어 퀴즈에 오신걸 환영합니다!",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: Text(
                      "퀴즈를 통해 신조어를 배워봐요!",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: 150,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white, width: 0.5),
                              borderRadius: BorderRadius.circular(15.0))),
                      onPressed: () {
                        signInWithGoogle();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            'http://pngimg.com/uploads/google/google_PNG19635.png',
                            fit: BoxFit.cover,
                            height: 50,
                          ),
                          Text(
                            "구글 로그인",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }
          return StreamBuilder(
              stream: FirebaseFirestore.instance.collection('user').snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final userdocs = snapshot.data!.docs;

                return ScreenPage();
              });
        });
  }
}

class ScreenPage extends StatefulWidget {
  const ScreenPage({super.key});

  @override
  State<ScreenPage> createState() => _ScreenPageState();
}

class _ScreenPageState extends State<ScreenPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => Scaffold(
          drawer: const MyDrawer(),
          backgroundColor: Get.find<BlackModeController>().blackmode == true
              ? blackmodecolor
              : notblackmodecolor,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.grey),
            toolbarHeight: 80.0,
            elevation: 0.0,
            centerTitle: true,
            title: const Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                "Neologism Quiz",
                style: TextStyle(
                    color: Colors.teal,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w700),
              ),
            ),
            backgroundColor: Get.find<BlackModeController>().blackmode == true
                ? blackmodecolor
                : notblackmodecolor,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/odong.png'),
                  backgroundColor:
                      Get.find<BlackModeController>().blackmode == true
                          ? blackmodecolor
                          : notblackmodecolor,
                  radius: 80.0,
                ),
                SizedBox(
                  width: 100,
                  child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          quiz_choice(context);
                        });
                      },
                      child: Text(
                        "시작하기",
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      )),
                ),
                MainPageButton(
                  page: NeologismDict(),
                  text: "신조어 사전",
                ),
                MainPageButton(
                  page: BulletinBoard(),
                  text: "건의 게시판",
                )
              ],
            ),
          )),
    );
  }
}
