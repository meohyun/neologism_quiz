import 'dart:io';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

rightSound() async {
  Soundpool pool = Soundpool.fromOptions();

  int soundId =
      await rootBundle.load("assets/correct.mp3").then((ByteData soundData) {
    return pool.load(soundData);
  });
  pool.play(soundId);

}

wrongSound() async {
  Soundpool pool = Soundpool.fromOptions();

  int soundId =
      await rootBundle.load("assets/wrong.mp3").then((ByteData soundData) {
    return pool.load(soundData);
  });
  pool.play(soundId);
  
}

gameEndSound() async {
  Soundpool pool = Soundpool.fromOptions();

  int soundId =
      await rootBundle.load("assets/game_end.mp3").then((ByteData soundData) {
    return pool.load(soundData);
  });
  pool.play(soundId);
}
