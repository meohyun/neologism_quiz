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

class BottomWidet {
  final String name;
  final IconData icon;
  final Function des;

  BottomWidet({required this.name, required this.icon, required this.des});
}

class MyBottomnavigator extends StatefulWidget {
  const MyBottomnavigator({super.key});

  @override
  State<MyBottomnavigator> createState() => _MyBottomnavigatorState();
}

class _MyBottomnavigatorState extends State<MyBottomnavigator> {
  final userid = FirebaseAuth.instance.currentUser!.uid;
  String intro = "";

  int pressedAttentionIndex = 0;
  @override
  Widget build(BuildContext context) {
    Get.put(BlackModeController());
    List<dynamic> mylist = [
      BottomWidet(
          name: "홈",
          icon: Icons.home,
          des: () {
            Get.to(() => const ScreenPage());
          }),
      BottomWidet(
          name: "게임",
          icon: CupertinoIcons.game_controller_solid,
          des: () {
            setState(() {
              quiz_choice(context);
            });
          }),
      BottomWidet(
          name: "신조어 사전",
          icon: CupertinoIcons.book_solid,
          des: () {
            Get.to(() => const NeologismDict());
          }),
      BottomWidet(
          name: "게시판",
          icon: CupertinoIcons.pen,
          des: () {
            Get.to(() => const BulletinBoard());
          }),
    ];
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Get.find<BlackModeController>().blackmode
                  ? Colors.black
                  : Colors.deepPurple[50],
              border: Border.all(width: 2, color: Colors.white),
              borderRadius: BorderRadius.circular(30)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: BottomAppBar(
                color: Get.find<BlackModeController>().blackmode
                    ? Colors.black
                    : Colors.deepPurple[50],
                height: 70,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: mylist.length,
                    itemBuilder: (context, index) {
                      final pressAttention = pressedAttentionIndex == index;
                      return Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              pressedAttentionIndex = index;
                            });
                          },
                          child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: pressAttention
                                  ? Container(
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: Colors.black))),
                                      height: 70,
                                      width: 90,
                                      child: MyIconButton(
                                          name: mylist[index].name,
                                          appicon: mylist[index].icon,
                                          des: mylist[index].des),
                                    )
                                  : SizedBox(
                                      height: 70,
                                      width: 90,
                                      child: MyIconButton(
                                          name: mylist[index].name,
                                          appicon: mylist[index].icon,
                                          des: mylist[index].des))),
                        ),
                      );
                    })),
          ),
        ),
      ),
    );
  }
}

class MyIconButton extends StatefulWidget {
  const MyIconButton({super.key, this.name, required this.des, this.appicon});

  final name;
  final appicon;
  final des;

  @override
  State<MyIconButton> createState() => _MyIconButtonState();
}

class _MyIconButtonState extends State<MyIconButton> {
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
            size: 30,
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
