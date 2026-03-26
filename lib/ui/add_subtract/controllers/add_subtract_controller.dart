import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/main.dart';
import 'package:kids_playroom/utils/color.dart';
import 'package:kids_playroom/utils/debug.dart';
import 'package:kids_playroom/utils/utils.dart';

class AddSubtractController extends GetxController {
  PageController? pageController =
  PageController(viewportFraction: 1.0, keepPage: true);

  bool? accept = false;
  int? answer;
  int? num1 = 1;
  int? num2 = 1;
  List<int>? options = [];
  int? totalQuestions = 20;
  int? currentQuestion = 1;
  bool? isDrag = false;
  dynamic args = Get.arguments;
  String? title;
  int? subId;
  Set<int>? optionSet = {};


  @override
  void onInit() {
    getDataFromArgs();
    generateNumbers();
    MyApp.flutterTts.stop();
     Utils.textToSpeech(title!, MyApp.flutterTts);
    super.onInit();
  }

  getDataFromArgs() {
    if (args != null) {
      if (args[0] != null) {
        title = args[0];
      }
      if (args[1] != null) {
        subId = args[1];
      }
    }
  }

  generateNumbers() {
    options!.clear();
    optionSet!.clear();
    do {
      num1 = Random().nextInt(30);
    } while (num1 == 0);

    if (subId == 14) {
      num2 = Random().nextInt(num1!);
    } else {
      num2 = Random().nextInt(30);
    }

    if (subId== 14) {
      answer = num1! - num2!;
    } else {
      answer = num1! + num2!;
    }

    int n1;
    int n2;
    optionSet!.add(answer!);
    do {
      do {
        n1 = Random().nextInt(60);
        do {
          n2 = Random().nextInt(60);
        } while (n2 == answer);
      } while (n1 == answer);
    } while (n1 == n2);
    Debug.printLog("n1: $n1");
    Debug.printLog("n2: $n2");
    Debug.printLog("ans $answer");


    optionSet!.add(n1);
    optionSet!.add(n2);


    options = optionSet!.toList();
    options!.shuffle();
    textSpeech();
  }

  textSpeech() {
    if (subId == 14) {
      MyApp.flutterTts.stop();
      Utils.textToSpeech("$num1 minus $num2 =", MyApp.flutterTts);
    } else {
      MyApp.flutterTts.stop();
      Utils.textToSpeech("$num1 + $num2 =", MyApp.flutterTts);
    }
  }

  answerColor() {
    if (options![0] == answer) {
      return AppColor.violetSquare;
    } else if (options![1] == answer) {
      return AppColor.redSquare;
    } else {
      return AppColor.blueSquare;
    }}
}