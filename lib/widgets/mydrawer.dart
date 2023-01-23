import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/neo_function/login_func.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => Drawer(
        backgroundColor: Get.find<BlackModeController>().blackmode == true
            ? Colors.grey
            : Colors.deepPurple[100],
        elevation: 0.0,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                    color: Get.find<BlackModeController>().blackmode == true
                        ? Colors.grey[600]
                        : Colors.deepPurple[200],
                    borderRadius: BorderRadius.circular(40)),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage("assets/odong.png"),
                  backgroundColor:
                      Get.find<BlackModeController>().blackmode == true
                          ? Colors.grey[600]
                          : Colors.deepPurple[200],
                ),
                accountName: Text(
                  "${FirebaseAuth.instance.currentUser!.displayName}",
                  style: TextStyle(fontSize: 20),
                ),
                accountEmail: Text(
                  "${FirebaseAuth.instance.currentUser!.email}",
                  style: TextStyle(fontSize: 20),
                )),
            ListTile(
                leading: Icon(
                  Icons.logout_rounded,
                  color: Get.find<BlackModeController>().blackmode == true
                      ? Colors.white
                      : Colors.black,
                ),
                title: Text("로그아웃",
                    style: TextStyle(
                      fontSize: 20,
                      color: Get.find<BlackModeController>().blackmode == true
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
