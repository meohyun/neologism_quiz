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
    Get.put(BlackModeController());
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.white),
              borderRadius: BorderRadius.circular(30)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BottomAppBar(
              color: Get.find<BlackModeController>().blackmode
                  ? Colors.black
                  : Colors.deepPurple[50],
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BottomAppWidget(
                      appicon: Icons.home,
                      name: "홈",
                      des: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const ScreenPage();
                        }));
                      }),
                  BottomAppWidget(
                      appicon: CupertinoIcons.game_controller_solid,
                      name: "게임",
                      des: () {
                        setState(() {
                          quiz_choice(context);
                        });
                      }),
                  BottomAppWidget(
                      appicon: CupertinoIcons.book_solid,
                      name: "신조어 사전",
                      des: () {
                        Get.to(NeologismDict());
                      }),
                  BottomAppWidget(
                      appicon: CupertinoIcons.pencil,
                      name: "게시판",
                      des: () {
                        Get.to(const BulletinBoard());
                      }),
                  BottomAppWidget(
                      appicon: Icons.dark_mode,
                      name: "다크모드",
                      des: () {
                        setState(() {
                          Get.find<BlackModeController>().blackmodechange();
                        });
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomAppWidget extends StatefulWidget {
  const BottomAppWidget(
      {super.key, this.name, required this.des, this.appicon});

  final name;
  final appicon;
  final des;

  @override
  State<BottomAppWidget> createState() => _BottomAppWidgetState();
}

class _BottomAppWidgetState extends State<BottomAppWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.des,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.appicon,
            color: Get.find<BlackModeController>().blackmode
                ? Colors.white
                : Colors.black,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            widget.name,
            style: TextStyle(
                color: Get.find<BlackModeController>().blackmode
                    ? Colors.white
                    : Colors.black),
          )
        ],
      ),
    );
  }
}
