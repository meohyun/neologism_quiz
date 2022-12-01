import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/neo_function/quiz_func.dart';
import 'package:neologism/widgets/Buttons.dart';

var blackmodecolor = Colors.black;
var notblackmodecolor = Colors.deepPurple[100];

class Startpage extends StatefulWidget {
  @override
  State<Startpage> createState() => _StartpageState();
}

class _StartpageState extends State<Startpage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => Scaffold(
        backgroundColor: Get.find<BlackModeController>().blackmode == true
            ? blackmodecolor
            : notblackmodecolor,
        appBar: AppBar(
          leading: SizedBox(),
          //leading: SizedBox(),
          // leading: Builder(
          //     builder: (context) => IconButton(
          //         onPressed: () {
          //           Scaffold.of(context).openDrawer();
          //         },
          //         icon: Icon(
          //           Icons.menu_rounded,
          //           color: blackmode == true ? Colors.white : Colors.blue,
          //         ))),
          elevation: 0.0,
          toolbarHeight: 100.0,
          centerTitle: true,
          title: const Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Text(
              "Neologism Quiz",
              style: TextStyle(
                  color: Colors.teal,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w700),
            ),
          ),
          backgroundColor: Get.find<BlackModeController>().blackmode == true
              ? blackmodecolor
              : notblackmodecolor,
          actions: [
            Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                child: BlackModeButton())
          ],
        ),
        //drawer: MyDrawer(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/odong.png'),
                backgroundColor:
                    Get.find<BlackModeController>().blackmode == true
                        ? blackmodecolor
                        : notblackmodecolor,
                radius: 80.0,
              ),
              SizedBox(
                width: 100,
                child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        quiz_choice(context);
                      });
                    },
                    child: Text(
                      "시작하기",
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    )),
              ),
              const MainPageButton(
                page: '/dict',
                text: "신조어 사전",
              )
            ],
          ),
        ),
      ),
    );
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
