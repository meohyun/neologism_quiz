import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neologism/getx/blackmode.dart';
import 'package:neologism/neo_function/quiz_func.dart';
import 'package:neologism/pages/startpage.dart';

class QuizAppBar extends StatefulWidget implements PreferredSizeWidget {
  const QuizAppBar(
      {super.key, required this.apptitle, required this.blackbutton});
  final String apptitle;
  final Widget blackbutton;

  @override
  Size get preferredSize => Size.fromHeight(60.0);

  @override
  State<QuizAppBar> createState() => _QuizAppBarState();
}

class _QuizAppBarState extends State<QuizAppBar> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: BlackModeController(),
      builder: (_) => AppBar(
        backgroundColor: Get.find<BlackModeController>().blackmode == true
            ? blackmodecolor
            : notblackmodecolor,
        centerTitle: false,
        title: Text(
          widget.apptitle,
          style:
              TextStyle(fontFamily: 'MapleStory', fontWeight: FontWeight.bold),
        ),
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: Get.find<BlackModeController>().blackmode == true
                ? Colors.white
                : blackmodecolor,
          ),
          onTap: () {
            quizexit(context);
          },
        ),
        actions: [widget.blackbutton],
        elevation: 2.0,
        shadowColor: Get.find<BlackModeController>().blackmode == true
            ? Colors.white
            : blackmodecolor,
        titleTextStyle: TextTheme(
                headline6: TextStyle(
                    color: Get.find<BlackModeController>().blackmode == true
                        ? Colors.white
                        : blackmodecolor,
                    fontSize: 20.0))
            .headline6,
      ),
    );
  }
}
