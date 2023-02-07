import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";
import 'package:neologism/firebase_options.dart';
import 'package:neologism/pages/bulletin_pages/bulletin_board.dart';
import 'package:neologism/pages/bulletin_pages/create.dart';
import 'package:neologism/pages/bulletin_pages/post_page.dart';
import 'package:neologism/pages/dictionary_page/dict_neologism.dart';
import 'package:neologism/pages/quiz_page/essay_quiz.dart';
import 'package:neologism/pages/quiz_page/word_quiz.dart';
import 'package:neologism/pages/startpage.dart';

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
        '/create': (context) => BulletinCreate(),
        '/post': (context) => BulletinPost()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
