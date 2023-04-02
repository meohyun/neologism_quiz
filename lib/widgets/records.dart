import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:neologism/getx/blackmode.dart';
import '../pages/startpage.dart';

class GameRecord extends StatefulWidget {
  const GameRecord({super.key, this.userid});

  final userid;

  @override
  State<GameRecord> createState() => _GameRecodrState();
}

class _GameRecodrState extends State<GameRecord> {
  final blackmode = Get.find<BlackModeController>().blackmode;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map>>(
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc('userdatabase')
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot<Map>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          final userdocs = snapshot.data![widget.userid]['result'];

          return ListView.builder(
              itemCount: userdocs.length,
              itemBuilder: (context, index) {
                final timestamp = userdocs[index]['time'];
                DateTime dt = timestamp.toDate();
                final mytime = DateFormat('MM.dd HH:mm').format(dt);
                return GetBuilder(
                  init: BlackModeController(),
                  builder: (_) => Column(
                    children: [
                      ListTile(
                        title: Text(
                          "맞춘개수 : ${userdocs[index]['result']}",
                          style: TextStyle(
                              fontSize: 20,
                              color: Get.find<BlackModeController>().blackmode
                                  ? Colors.white
                                  : blackmodecolor),
                        ),
                        subtitle: userdocs[index]['type'] == "WordQuiz"
                            ? Text("단어퀴즈",
                                style: TextStyle(
                                    color: Get.find<BlackModeController>()
                                            .blackmode
                                        ? Colors.white
                                        : blackmodecolor))
                            : Text("문장퀴즈",
                                style: TextStyle(
                                    color: Get.find<BlackModeController>()
                                            .blackmode
                                        ? Colors.white
                                        : blackmodecolor)),
                        trailing: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Opacity(
                              opacity: 0.6,
                              child: Text(mytime.toString(),
                                  style: TextStyle(
                                      color: Get.find<BlackModeController>()
                                              .blackmode
                                          ? Colors.white
                                          : blackmodecolor))),
                        ),
                      ),
                      Divider(
                        height: 10,
                        thickness: 2,
                        color: Get.find<BlackModeController>().blackmode
                            ? Colors.white
                            : blackmodecolor,
                      )
                    ],
                  ),
                );
              });
        });
  }
}
