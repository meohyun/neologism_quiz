import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/getx/profileimage.dart';
import 'package:neologism/neo_function/settings.dart';
import 'package:neologism/pages/user_page/profile.dart';

String intro = "";

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
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
    getprofile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileImageController());
    final user = FirebaseAuth.instance.currentUser!.displayName;
    final userid = FirebaseAuth.instance.currentUser!.uid;
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => Drawer(
        backgroundColor: Get.find<BlackModeController>().blackmode
            ? Colors.grey
            : Colors.deepPurple[100],
        elevation: 0.0,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                    color: Get.find<BlackModeController>().blackmode
                        ? Colors.grey[600]
                        : Colors.deepPurple[200],
                    borderRadius: BorderRadius.circular(40)),
                currentAccountPicture: Obx(() => CircleAvatar(
                      backgroundImage:
                          profileimagecontroller.isProfilePath.value == true
                              ? NetworkImage(
                                      profileimagecontroller.profilePath.value)
                                  as ImageProvider
                              : const AssetImage(
                                  "assets/userimage3.png",
                                ),
                      radius: 35,
                    )),
                accountName:
                    Text(user.toString(), style: const TextStyle(fontSize: 20)),
                accountEmail: null),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              leading: Icon(
                Icons.dark_mode,
                color: Get.find<BlackModeController>().blackmode
                    ? Colors.yellow
                    : Colors.grey,
              ),
              title: Text(
                "다크 모드",
                style: TextStyle(
                  fontSize: 20,
                  color: Get.find<BlackModeController>().blackmode
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              onTap: () {
                Get.find<BlackModeController>().blackmodechange();
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
                leading: Icon(
                  Icons.person,
                  color: Get.find<BlackModeController>().blackmode
                      ? Colors.white
                      : Colors.black,
                ),
                title: Text("내 정보",
                    style: TextStyle(
                      fontSize: 20,
                      color: Get.find<BlackModeController>().blackmode
                          ? Colors.white
                          : Colors.black,
                    )),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return UserProfile(
                      userid: userid,
                      imagepath: profileimagecontroller.profilePath.value,
                      hasimage: profileimagecontroller.isProfilePath.value,
                      intro: intro,
                    );
                  }));
                }),
            const SizedBox(
              height: 20,
            ),
            ListTile(
                leading: Icon(
                  Icons.logout_rounded,
                  color: Get.find<BlackModeController>().blackmode
                      ? Colors.white
                      : Colors.black,
                ),
                title: Text("로그아웃",
                    style: TextStyle(
                      fontSize: 20,
                      color: Get.find<BlackModeController>().blackmode
                          ? Colors.white
                          : Colors.black,
                    )),
                onTap: () {
                  setState(() {
                    logout(context);
                  });
                }),
          ],
        ),
      ),
    );
  }
}
