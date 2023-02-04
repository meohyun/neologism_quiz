import 'package:neologism/neo_function/quiz_func.dart';
import 'package:neologism/pages/essay_quiz.dart';
import 'package:neologism/datas/sentence_data.dart';

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

// essayquiz show split hint
// showsplithint() {
//   List split_list = sen_data[order]["answer"].toString().split('');
//   int word_num = Random().nextInt(split_list.length);
//   String split_hint = split_list[word_num];
//   return split_hint;
// }