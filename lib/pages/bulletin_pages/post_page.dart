import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/pages/startpage.dart';

class BulletinPost extends StatelessWidget {
  const BulletinPost(
      {super.key,
      this.index,
      this.user,
      this.name,
      this.content,
      this.datetime});

  final index;
  final user;
  final name;
  final content;
  final datetime;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text("건의 게시판",
              style: TextStyle(
                color: Get.find<BlackModeController>().blackmode
                    ? Colors.white
                    : blackmodecolor,
              )),
          elevation: 0.0,
          backgroundColor: Get.find<BlackModeController>().blackmode
              ? blackmodecolor
              : notblackmodecolor,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(CupertinoIcons.pen),
              iconSize: 30,
              color: Get.find<BlackModeController>().blackmode
                  ? Colors.white
                  : blackmodecolor,
            ),
            IconButton(
                onPressed: () {},
                icon: Icon(CupertinoIcons.delete,
                    color: Get.find<BlackModeController>().blackmode
                        ? Colors.white
                        : blackmodecolor))
          ],
        ),
        body: Container(
          color: Get.find<BlackModeController>().blackmode
              ? blackmodecolor
              : notblackmodecolor,
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 80,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(width: 2, color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  user.toString(),
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                Text(datetime.toString()),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                name,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 500,
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      border: Border.all(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      content,
                      style: TextStyle(fontSize: 18),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
