import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:neologism/widgets/bulletin.dart';

class BulletinSearch extends StatefulWidget {
  const BulletinSearch({super.key});

  @override
  State<BulletinSearch> createState() => _BulletinSearchState();
}

class _BulletinSearchState extends State<BulletinSearch> {
  String name = "";
  @override
  Widget build(BuildContext context) {
    final blackmode = Get.find<BlackModeController>().blackmode;
    return GetBuilder(
      init: BlackModeController(),
      builder:(_)=> Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: blackmode ? blackmodecolor : notblackmodecolor,
        appBar: AppBar(
          backgroundColor: blackmode ? blackmodecolor : notblackmodecolor ,
          title: Card(
            child: TextField(
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search), hintText: "검색어를 입력해주세요."),
              onChanged: (value) {
                name = value;
              },
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('post').orderBy('time', descending: true).snapshots(),
            builder: (context, snapshots) {
              if (snapshots.connectionState == ConnectionState.waiting){
                return const Center(
                      child: CircularProgressIndicator());
              }
              var data = snapshots.data!.docs;
              return BulletinTile(docs: data,);                            
            }),
      ),
    );
  }
}
