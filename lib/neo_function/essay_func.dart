import 'package:neologism/datas/quizdata.dart';
import 'package:neologism/neo_function/quiz_func.dart';
import 'package:neologism/datas/sentence_data.dart';
import 'package:neologism/pages/quiz_page/essay_quiz.dart';

isanswer(value) {
  if (value.toString().toUpperCase() == sen_data[order]["answer"].toString()) {
    essay_running = false;
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

essaynextpage() {
  answer = false;
  answershow = false;
  order = makenumber(datas.length)[idx - 1];
  hintclicked = false;
  hintblocked = false;
  idx++;
  essay_answershow = false;
  textcontroller.clear();
  typetext = true;
  answer_chance = 3;
  wordhint = "";
  essayTime = 15;
  essay_running = true;
}
