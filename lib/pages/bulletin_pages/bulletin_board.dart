import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/pages/bulletin_pages/postCRUD.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:intl/intl.dart';
import 'package:neologism/search/bulletin_search.dart';
import 'package:neologism/widgets/bottom_navigation.dart';
import 'package:neologism/widgets/bulletin.dart';

class BulletinBoard extends StatefulWidget {
  const BulletinBoard({super.key});

  @override
  State<BulletinBoard> createState() => _BulletinBoardState();
}

class _BulletinBoardState extends State<BulletinBoard> {
  int index = 3;
  getAdminName() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userid = user.uid;
    final username = user.displayName;

    var collection = FirebaseFirestore.instance.collection('post');
    var querySnapshots = await collection.get();
    // get documents id
    for (var snapshot in querySnapshots.docs) {
      String documentID = snapshot.id;

      FirebaseFirestore.instance
          .collection('post')
          .doc(documentID)
          .get()
          .then((DocumentSnapshot doc) {
        final datas = doc.data() as Map<String, dynamic>;
        final adminid = datas['admin']['userid'];
        // if adminid = current userid,update username
        if (adminid == userid) {
          FirebaseFirestore.instance
              .collection('post')
              .doc(documentID)
              .update({"admin.usernickname": username});
        }
      });
    }
  }

  @override
  void initState() {
    index = 3;
    getAdminName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: BlackModeController(),
        builder: (_) => Scaffold(
              backgroundColor: Get.find<BlackModeController>().blackmode
                  ? blackmodecolor
                  : notblackmodecolor,
              bottomNavigationBar: MyBottomnavigator(index: index),
              appBar: AppBar(
                shadowColor: Colors.white,
                leading: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    icon: const Icon(Icons.arrow_back)),
                backgroundColor: Get.find<BlackModeController>().blackmode
                    ? blackmodecolor
                    : notblackmodecolor,
                title: Text(
                  "게시판",
                  style: TextStyle(
                    color: Get.find<BlackModeController>().blackmode
                        ? Colors.white
                        : blackmodecolor,
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Get.to(()=>const BulletinCreate());
                      },
                      child: Text(
                        "글쓰기",
                        style: TextStyle(
                          fontSize: 18,
                            color: Get.find<BlackModeController>().blackmode
                                ? Colors.white
                                : blackmodecolor),
                      )),
                  IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const BulletinSearch();
                        }));
                      },
                      icon: Icon(
                        Icons.search,
                        color: Get.find<BlackModeController>().blackmode
                            ? Colors.white
                            : blackmodecolor,
                      ))
                ],
              ),
              body: Stack(
                children: [
                  Positioned(
                    child: Container(
                      color: Get.find<BlackModeController>().blackmode
                          ? blackmodecolor
                          : notblackmodecolor,
                    ),
                  ),
                  Positioned(
                    child: Container(
                      color: Colors.white30,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: const Blluettin(),
                    ),
                  ),
                ],
              ),
            ));
  }
}

class Blluettin extends StatelessWidget {
  const Blluettin({super.key});

  @override
  Widget build(BuildContext context) {
    final userid = FirebaseAuth.instance.currentUser!.uid;
    final board = FirebaseFirestore.instance.collection('post');
    return StreamBuilder(
        stream: board.orderBy('time', descending: true).snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final postDocs = snapshot.data!.docs;
          return BulletinTile(docs: postDocs);
        });
  }
}
