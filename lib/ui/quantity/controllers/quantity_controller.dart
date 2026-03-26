import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/main.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/debug.dart';
import 'package:kids_playroom/utils/utils.dart';

class QuantityController extends GetxController{
  PageController? pageController =
  PageController(viewportFraction: 1.0, keepPage: true);
  bool? accept = false;
  int? totalQue = 20;
  int? currentQue = 1;

  List<int> options = [];
  int? countAnswer;

  List<int> numQue = [];

  @override
  void onInit() {
    getNumbers();
    getOptions(0);
    super.onInit();
  }

  getNumbers() {
    List<int> numbers = List.generate(30, (index) => index+1);
    numbers.shuffle();
    numQue = numbers.sample(20);
    Debug.printLog(numQue.toString());
  }

  getOptions(int index) {
    countAnswer = numQue[index];
    Debug.printLog("answer : $countAnswer");

    Set<int> opt = {};

    opt.add(countAnswer!);
    do{
      int num;
      do{
        num = Random().nextInt(totalQue!);
      } while (num == 0);
      opt.add(num);
    } while(opt.length != 15);

    Debug.printLog("options: $opt");
    options = opt.toList();
    options.shuffle();
    MyApp.flutterTts.stop();
    Utils.textToSpeech(Constant.txtHowManyObjects, MyApp.flutterTts);
  }


}