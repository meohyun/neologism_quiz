import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";
import 'package:neologism/bulletin_pages/create.dart';
import 'package:neologism/firebase_options.dart';
import 'package:neologism/bulletin_pages/bulletin_board.dart';
import 'package:neologism/pages/dict_neologism.dart';
import 'package:neologism/pages/essay_quiz.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:neologism/pages/word_quiz.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(Neologism());
}

class Neologism extends StatefulWidget {
  const Neologism({super.key});

  @override
  State<Neologism> createState() => _NeologismState();
}

class _NeologismState extends State<Neologism> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "신조어 퀴즈",
      initialRoute: '/',
      theme: ThemeData(
        fontFamily: 'MapleStory',
      ),
      routes: {
        '/': (context) => Startpage(),
        '/word': (context) => NeologismQuiz(),
        '/dict': (context) => NeologismDict(),
        '/sentence': (context) => EssayQuiz(),
        '/bulletin': (context) => Bulletin_Board(),
        '/create': (context) => BulletinCreate()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
