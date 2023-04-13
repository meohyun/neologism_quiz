import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import "package:flutter/material.dart";
import 'package:get/route_manager.dart';
import 'package:neologism/firebase_options.dart';
import 'package:neologism/pages/bulletin_pages/bulletin_board.dart';
import 'package:neologism/pages/bulletin_pages/postCRUD.dart';
import 'package:neologism/pages/bulletin_pages/post_page.dart';
import 'package:neologism/pages/dictionary_page/dict_neologism.dart';
import 'package:neologism/pages/quiz_page/essay_quiz.dart';
import 'package:neologism/pages/quiz_page/word_quiz.dart';
import 'package:neologism/pages/startpage.dart';


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const Neologism());
}

class Neologism extends StatefulWidget {
  const Neologism({super.key});

  @override
  State<Neologism> createState() => _NeologismState();
}

class _NeologismState extends State<Neologism> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "신조어 퀴즈",
      initialRoute: '/',
      theme: ThemeData(
        fontFamily: 'MapleStory',
      ),
      useInheritedMediaQuery: true,
      routes: {
        '/': (context) => Startpage(),
        '/word': (context) => NeologismQuiz(),
        '/dict': (context) => NeologismDict(),
        '/sentence': (context) => EssayQuiz(),
        '/bulletin': (context) => const BulletinBoard(),
        '/create': (context) => const BulletinCreate(),
        '/post': (context) => const BulletinPost(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
