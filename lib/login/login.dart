import 'package:flutter/material.dart';
import 'package:neologism/login/login_func.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
            child: GestureDetector(
          onTap: () async {
            try {
              await AuthService().signInWithGoogle();
            } catch (e) {
              null;
            }
          },
          child: Image(image: AssetImage('assets/odong.png')),
        )));
  }
}
