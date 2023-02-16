import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/neo_function/login_func.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:neologism/widgets/Buttons.dart';

String usernickname = "";

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key, this.nickname});
  final nickname;

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!.displayName;
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
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage("assets/odong.png"),
                  backgroundColor: Get.find<BlackModeController>().blackmode
                      ? Colors.grey[600]
                      : Colors.deepPurple[200],
                ),
                accountName: widget.nickname == null
                    ? Text(user.toString(), style: TextStyle(fontSize: 20))
                    : Text(
                        widget.nickname,
                        style: TextStyle(fontSize: 20),
                      ),
                accountEmail: Text(
                  "${FirebaseAuth.instance.currentUser!.email}",
                  style: TextStyle(fontSize: 20),
                )),
            SizedBox(
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
            SizedBox(
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
