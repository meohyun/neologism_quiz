import 'package:flutter/material.dart';
import 'package:neologism/neo_function/quiz_func.dart';
import 'package:neologism/pages/startpage.dart';

bool pagenext = true;

//main button
class MainPageButton extends StatelessWidget {
  const MainPageButton({super.key, required this.page, this.text});

  final String page;
  final text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
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
      ),
    );
  }
}

// nextpagebutton
class NextButton extends StatefulWidget {
  NextButton({super.key, required this.page});

  final page;

  @override
  State<NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: Colors.blue[400],
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.circular(15.0))),
          onPressed: () {
            setState(() {
              if (idx < 10) {
                nextpage();
              } else {
                endpage(context, '/sentence');
              }
            });
          },
          child: Text(
            "다음",
            style: TextStyle(color: Colors.white),
          )),
    );
  }
}

//blackmode
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
