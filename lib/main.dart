import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";
import 'package:neologism/firebase_options.dart';
import 'package:neologism/login/login_func.dart';

void main() async {
  // 메인메소드 내에서 비동기 방식으로 불러오고 initiallizeapp을 불러온다.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(Neologism());
}

class Neologism extends StatelessWidget {
  const Neologism({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "신조어 퀴즈",
      debugShowCheckedModeBanner: false,
      home: AuthService().handleAuthState(),
    );
  }
}
