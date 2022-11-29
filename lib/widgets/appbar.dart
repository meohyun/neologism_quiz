import 'package:flutter/material.dart';
import 'package:neologism/neo_function/quiz_func.dart';
import 'package:neologism/pages/startpage.dart';
import 'package:neologism/widgets/Buttons.dart';

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
    return AppBar(
      backgroundColor: blackmode == true ? blackmodecolor : notblackmodecolor,
      centerTitle: false,
      title: Text(
        widget.apptitle,
        style: TextStyle(fontFamily: 'MapleStory', fontWeight: FontWeight.bold),
      ),
      leading: GestureDetector(
        child: Icon(
          Icons.arrow_back_ios,
          color: blackmode == true ? Colors.white : blackmodecolor,
        ),
        onTap: () {
          quizexit(context);
        },
      ),
      actions: [widget.blackbutton],
      elevation: 2.0,
      shadowColor: blackmode == true ? Colors.white : blackmodecolor,
      titleTextStyle: TextTheme(
              headline6: TextStyle(
                  color: blackmode == true ? Colors.white : blackmodecolor,
                  fontSize: 20.0))
          .headline6,
    );
  }
}
