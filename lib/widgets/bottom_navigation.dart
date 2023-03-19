import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neologism/neo_function/quiz_func.dart';
import 'package:neologism/pages/bulletin_pages/bulletin_board.dart';
import 'package:neologism/pages/dictionary_page/dict_neologism.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:neologism/pages/user_page/profile.dart';

import '../getx/blackmode.dart';

class MyBottomnavigator extends StatefulWidget {
  const MyBottomnavigator({super.key});

  @override
  State<MyBottomnavigator> createState() => _MyBottomnavigatorState();
}

class _MyBottomnavigatorState extends State<MyBottomnavigator> {
  final userid = FirebaseAuth.instance.currentUser!.uid;
  String intro = "";

  getprofile() {
    final useruid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('user')
        .doc('userdatabase')
        .get()
        .then((value) {
      final data = value.data();
      profileimagecontroller.profilePath.value = data![useruid]['imagepath'];
      profileimagecontroller.isProfilePath.value = data[useruid]['hasimage'];
      intro = data[useruid]['intro'];
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int index = 0;
    return BottomAppBar(
      color: Colors.deepPurple[50],
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const Startpage();
              }));
            },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home),
                SizedBox(
                  height: 5,
                ),
                Text("홈")
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                quiz_choice(context);
              });
            },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.game_controller_solid),
                SizedBox(
                  height: 5,
                ),
                Text("게임")
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return NeologismDict();
              }));
            },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.book_fill),
                SizedBox(
                  height: 5,
                ),
                Text("신조어 사전")
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.to(const BulletinBoard());
            },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.pencil),
                SizedBox(
                  height: 5,
                ),
                Text("게시판")
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.find<BlackModeController>().blackmodechange();
            },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.dark_mode,
                  size: 30,
                ),
                SizedBox(
                  height: 5,
                ),
                Text("다크 모드")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
