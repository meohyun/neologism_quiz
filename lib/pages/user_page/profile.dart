import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/getx/profileimage.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:intl/intl.dart';
import 'package:neologism/pages/user_page/nickname.dart';
import 'package:neologism/widgets/bottom_navigation.dart';

ProfileImageController profileimagecontroller =
    Get.find<ProfileImageController>();
String userintro = "";

class UserProfile extends StatefulWidget {
  const UserProfile(
      {super.key,
      this.name,
      this.userid,
      this.imagepath,
      this.hasimage,
      this.intro,
      this.route});

  final name;
  final userid;
  final imagepath;
  final hasimage;
  final intro;
  final route;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  getuserprofile() {
    FirebaseFirestore.instance
        .collection('user')
        .doc('userdatabase')
        .get()
        .then((value) {
      final datas = value.data();
      setState(() {
        userintro = datas![widget.userid]['intro'];
      });
    });
  }

  @override
  void initState() {
    final _auth = FirebaseAuth.instance.currentUser!;
    _auth.reload();
    getuserprofile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileImageController());
    final useruid = FirebaseAuth.instance.currentUser!.uid;
    final blackmode = Get.find<BlackModeController>().blackmode;
    final username = FirebaseAuth.instance.currentUser!.displayName;
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => Scaffold(
          backgroundColor: blackmode ? blackmodecolor : notblackmodecolor,
          bottomNavigationBar: const MyBottomnavigator(),
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  if (widget.route == null) {
                    Get.back();
                  } else {
                    Get.to(widget.route);
                  }
                },
                icon: const Icon(Icons.arrow_back)),
            title: Text(
              "유저 정보",
              style: TextStyle(
                  color: blackmode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              widget.userid == useruid
                  ? IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return UpdateNickname(
                            intro: widget.intro,
                          );
                        }));
                      },
                      icon: Icon(
                        Icons.edit,
                        color: blackmode ? Colors.white : blackmodecolor,
                        size: 25,
                      ))
                  : const SizedBox()
            ],
            backgroundColor: blackmode ? blackmodecolor : notblackmodecolor,
            elevation: 0.0,
          ),
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              color: blackmode ? blackmodecolor : notblackmodecolor,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  CircleAvatar(
                    backgroundImage: widget.hasimage == true
                        ? NetworkImage(widget.imagepath) as ImageProvider
                        : const AssetImage(
                            "assets/userimage3.png",
                          ),
                    radius: 35,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  widget.name == null
                      ? Text(
                          username.toString(),
                          style: TextStyle(
                              fontSize: 20,
                              color: blackmode ? Colors.white : blackmodecolor,
                              fontWeight: FontWeight.bold),
                        )
                      : Text(
                          widget.name,
                          style: TextStyle(
                              fontSize: 20,
                              color: blackmode ? Colors.white : blackmodecolor,
                              fontWeight: FontWeight.bold),
                        ),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color:
                                    blackmode ? Colors.white : blackmodecolor,
                              ),
                              borderRadius: BorderRadius.circular(15)),
                          height: 80,
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: userintro == ""
                                ? Text(
                                    "자기소개가 없습니다.",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: blackmode
                                            ? Colors.white
                                            : blackmodecolor),
                                  )
                                : Text(
                                    userintro,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: blackmode
                                            ? Colors.white
                                            : blackmodecolor),
                                  ),
                          ))
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                        child: Text(
                          "게임 기록",
                          style: TextStyle(
                              fontSize: 20,
                              color: blackmode ? Colors.white : blackmodecolor),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 30,
                    thickness: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: StreamBuilder<DocumentSnapshot<Map>>(
                            stream: FirebaseFirestore.instance
                                .collection('user')
                                .doc('userdatabase')
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<DocumentSnapshot<Map>> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              final userdocs =
                                  snapshot.data![widget.userid]['result'];
                              return ListView.builder(
                                  itemCount: userdocs.length,
                                  itemBuilder: (context, index) {
                                    final timestamp = userdocs[index]['time'];
                                    DateTime dt = timestamp.toDate();
                                    final mytime =
                                        DateFormat('MM.dd HH:mm').format(dt);
                                    return Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                            "맞춘개수 : ${userdocs[index]['result']}",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: blackmode
                                                    ? Colors.white
                                                    : blackmodecolor),
                                          ),
                                          subtitle: userdocs[index]['type'] ==
                                                  "WordQuiz"
                                              ? Text("단어퀴즈",
                                                  style: TextStyle(
                                                      color: blackmode
                                                          ? Colors.white
                                                          : blackmodecolor))
                                              : Text("문장퀴즈",
                                                  style: TextStyle(
                                                      color: blackmode
                                                          ? Colors.white
                                                          : blackmodecolor)),
                                          trailing: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Opacity(
                                                opacity: 0.6,
                                                child: Text(mytime.toString(),
                                                    style: TextStyle(
                                                        color: blackmode
                                                            ? Colors.white
                                                            : blackmodecolor))),
                                          ),
                                        ),
                                        const Divider(
                                          height: 10,
                                          thickness: 1.5,
                                        )
                                      ],
                                    );
                                  });
                            }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
