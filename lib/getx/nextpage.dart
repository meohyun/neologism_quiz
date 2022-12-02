import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:neologism/datas/quizdata.dart';
import 'package:neologism/neo_function/quiz_func.dart';

class NextPageController extends GetxController {
  bool _answer = false;
  bool _answershow = false;
  bool _hintclicked = false;
  bool _hintblocked = false;
  bool _descblocked = false;
  bool _typetext = true;
  int _order = makenumber(datas.length)[0];
  int _idx = 1;
  int _hint_num = 5;
  int _number_answer = 0;
  int _answer_chance = 3;
  String _wordhint = "";
  TextEditingController _textcontroller = TextEditingController();

  bool get answer => _answer;
  bool get answershow => _answershow;
  bool get hintclicked => _hintclicked;
  bool get hintblocked => _hintblocked;
  bool get descblocked => _descblocked;
  bool get typetext => _typetext;
  int get order => _order;
  int get idx => _idx;
  int get hint_num => _hint_num;
  int get number_answer => _number_answer;
  int get answer_chance => _answer_chance;
  String get wordhint => _wordhint;

  void nextpage() {
    _answer = false;
    _answershow = false;
    _order = makenumber(datas.length)[idx - 1];
    _hintclicked = false;
    _hintblocked = false;
    _idx++;
    _textcontroller.clear();
    _typetext = true;
    _answer_chance = 3;
    _wordhint = "";
    _descblocked = false;
    update();
  }

  void clickhint() {
    _hint_num--;
    _hintclicked = true;
  }
}
