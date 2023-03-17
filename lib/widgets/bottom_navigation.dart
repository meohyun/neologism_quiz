import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neologism/getx/blackmode.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({super.key});

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {

  int index = 0;
  @override
  Widget build(BuildContext context) {
    final blackmode = Get.find<BlackModeController>().blackmode;
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => NavigationBarTheme(
        data: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.all(const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ))),
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (value){
            setState(() {
              index = value;
            });
          },
            backgroundColor: blackmode ? Colors.grey : Colors.white,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: "홈"),
              NavigationDestination(
                  icon: Icon(CupertinoIcons.game_controller), label: "퀴즈"),
              NavigationDestination(icon: Icon(Icons.book), label: "신조어 사전"),
            ]),
      ),
    );
  }
}
