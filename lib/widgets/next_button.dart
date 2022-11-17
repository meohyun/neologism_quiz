import 'package:flutter/material.dart';
import 'package:neologism/neo_function/quiz_func.dart';

class NextButton extends StatefulWidget {
  const NextButton({super.key, required this.page, required this.pageChanged});

  final page;
  final ValueChanged<Function()> pageChanged;

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
                endpage(context, widget.page);
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
