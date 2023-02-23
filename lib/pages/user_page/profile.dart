import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:intl/intl.dart';
import 'package:neologism/pages/user_page/nickname.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key, this.name, this.userid});

  final name;
  final userid;
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  void initState() {
    final _auth = FirebaseAuth.instance.currentUser!;
    _auth.reload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final blackmode = Get.find<BlackModeController>().blackmode;
    final useruid = FirebaseAuth.instance.currentUser!.uid;
    final username = FirebaseAuth.instance.currentUser!.displayName;
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const ScreenPage();
                  }));
                },
                icon: Icon(Icons.arrow_back)),
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
                          return UpdateNickname();
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
          body: Container(
            color: blackmode ? blackmodecolor : notblackmodecolor,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const CircleAvatar(
                  radius: 35,
                  child: Icon(
                    Icons.person,
                    size: 35,
                  ),
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        "게임 기록",
                        style: TextStyle(
                            fontSize: 20,
                            color: blackmode ? Colors.white : blackmodecolor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('user')
                          .doc('userdatabase')
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            child: Center(
                              child: Text(
                                "게임기록이 없습니다.",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        } else {
                          final userdocs =
                              snapshot.data![widget.userid]['result'];
                          return ListView.builder(
                              itemCount: userdocs.length,
                              itemBuilder: (context, index) {
                                final timestamp = userdocs[index]['time'];
                                DateTime dt = timestamp.toDate();
                                final mytime =
                                    DateFormat('MM.dd HH:mm').format(dt);
                                return ListTile(
                                  title: Text(
                                    "맞춘개수 : " + "${userdocs[index]['result']}",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: blackmode
                                            ? Colors.white
                                            : blackmodecolor),
                                  ),
                                  subtitle:
                                      userdocs[index]['type'] == "WordQuiz"
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
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Opacity(
                                        opacity: 0.6,
                                        child: Text(mytime.toString(),
                                            style: TextStyle(
                                                color: blackmode
                                                    ? Colors.white
                                                    : blackmodecolor))),
                                  ),
                                );
                              });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}