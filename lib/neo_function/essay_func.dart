import 'package:flutter/material.dart';
import 'package:neologism/neo_function/quiz_func.dart';
import 'package:neologism/pages/essay_quiz.dart';
import 'package:neologism/datas/sentence_data.dart';

isanswer(value) {
  if (value.toString().toUpperCase() == sen_data[order]["answer"].toString()) {
    answer = true;
    number_answer++;
    hintblocked = true;
    typetext = false;
  } else {
    answer_chance--;
  }
}

spellingnum() {
  List list = sen_data[order]["answer"].toString().split('');
  int nums = list.length;

  return nums;
}

Widget boxDecoration() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
    child: DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 20,
        ),
      ),
    ),
  );
}
