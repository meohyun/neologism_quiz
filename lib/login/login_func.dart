import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:neologism/login/login.dart';
import 'package:neologism/main.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SignInScreen(
                headerBuilder: (context, constraints, shrinkOffset) {
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image(image: AssetImage("assets/odong2.gif")),
                    ),
                  );
                },
                providerConfigs: [
                  //이메일 인증
                  EmailProviderConfiguration()
                ],
              );
            } else {
              return Startpage();
            }
          }),
    );
  }
}
