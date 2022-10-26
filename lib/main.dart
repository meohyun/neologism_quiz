import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neologism/dict_neologism.dart';
import 'package:neologism/firebase_options.dart';
import 'package:neologism/login/login_func.dart';
import 'package:neologism/neologismquiz.dart';

bool blackmode = false;
var blackmodecolor = Colors.black;
var notblackmodecolor = Colors.deepPurple[100];

void main() async {
  // 메인메소드 내에서 비동기 방식으로 불러오고 initiallizeapp을 불러온다.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Neologism());
}

class Neologism extends StatelessWidget {
  const Neologism({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "신조어 퀴즈",
      initialRoute: 'start',
      routes: {
        'start': (context) => LoginPage(),
        '/': (context) => Startpage(),
        '/neologism': (context) => NeologismQuiz(),
        '/dict': (context) => NeologismDict(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class Startpage extends StatefulWidget {
  @override
  State<Startpage> createState() => _StartpageState();
}

setinit() {
  bool blackmode = false;
}

class _StartpageState extends State<Startpage> {
  @override
  void initState() {
    super.initState();
    setinit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: blackmode == true ? blackmodecolor : notblackmodecolor,
        appBar: AppBar(
          leading: Builder(
              builder: (context) => IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(
                    Icons.menu_rounded,
                    color: blackmode == true ? Colors.white : Colors.blue,
                  ))),
          elevation: 0.0,
          toolbarHeight: 100.0,
          centerTitle: true,
          title: const Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Text(
              "Neologism Quiz",
              style: TextStyle(color: Colors.teal, fontSize: 25.0),
            ),
          ),
          backgroundColor:
              blackmode == true ? blackmodecolor : notblackmodecolor,
          actions: [
            Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                child: BlackModeButton(
                  ModeChanged: (value) => setState(() => blackmode = value),
                ))
          ],
        ),
        drawer: MyDrawer(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/odong.png'),
                backgroundColor:
                    blackmode == true ? blackmodecolor : notblackmodecolor,
                radius: 80.0,
              ),
              const MainPageButton(
                page: '/neologism',
                text: "시작하기",
              ),
              const MainPageButton(
                page: '/dict',
                text: "신조어 사전",
              )
            ],
          ),
        ));
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0.0,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/odong.png"),
                backgroundColor: Colors.blue,
              ),
              accountName: Text("daehyun"),
              accountEmail: Text("eogus1954@naver.com")),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("settings"),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("settings"),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("settings"),
          ),
        ],
      ),
    );
  }
}

//버튼
class MainPageButton extends StatelessWidget {
  const MainPageButton({super.key, required this.page, this.text});

  final String page;
  final text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(context, page);
          },
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          )),
    );
  }
}

class BlackModeButton extends StatefulWidget {
  const BlackModeButton({super.key, required this.ModeChanged});

  final ValueChanged<bool> ModeChanged;

  @override
  State<BlackModeButton> createState() => _BlackModeButtonState();
}

class _BlackModeButtonState extends State<BlackModeButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          widget.ModeChanged(blackmode);
          setState(() {
            blackmode = !blackmode;
          });
        },
        icon: Icon(
          Icons.dark_mode,
          color: blackmode == true ? Colors.yellow : Colors.grey,
        ));
  }
}
