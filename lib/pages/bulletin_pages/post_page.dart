import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BulletinPost extends StatelessWidget {
  const BulletinPost({super.key, this.index});

  final index;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!.displayName;

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('post').snapshots(),
        builder: ((context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          final postdocs = snapshot.data!.docs;
          final timestamp = postdocs[index]['time'];
          DateTime dt = timestamp.toDate();
          final d24 = DateFormat('yyyy/MM/dd HH:mm').format(dt);
          return Scaffold(
            appBar: AppBar(),
            body: Container(
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              border: Border.all(width: 2, color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  user.toString(),
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                Text(d24.toString()),
                              ],
                            ),
                          )),
                    ),
                  ),
                  Column(
                    children: [
                      Text(postdocs[index]['name']),
                      Text(postdocs[index]['contents'])
                    ],
                  ),
                ],
              ),
            ),
          );
        }));
  }
}
