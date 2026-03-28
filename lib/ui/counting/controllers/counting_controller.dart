import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/main.dart';
import 'package:kids_playroom/utils/color.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/debug.dart';
import 'package:kids_playroom/utils/utils.dart';

class CountingController extends GetxController {
  PageController? pageController =
      PageController(viewportFraction: 1.0, keepPage: true);
  bool? accept = false;

  bool? isDrag = false;

  int? currentQue = 1;
  int? totalQue = 20;

  List<int> options = [];
  int? countAnswer;

  List<int> numQue = [];
  dynamic args = Get.arguments;
  String title ="";
  int? subId;



  @override
  Future<void> onInit() async {
    getDataFromArgs();
    MyApp.flutterTts.stop();
    Utils.textToSpeech(title, MyApp.flutterTts);
    getNumbers();
    getOptions(0);
    super.onInit();
  }

  getNumbers() {
    List<int> numbers = List.generate(30, (index) => index + 1);
    numbers.shuffle();
    numQue = numbers.sample(20);
    Debug.printLog(numQue.toString());
    update([Constant.idCounting]);
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

  getOptions(int index) {
    countAnswer = numQue[index];
    Debug.printLog("answer : $countAnswer");
    Set<int> opt = {};

    opt.add(countAnswer!);
    if (countAnswer! < 8) {
      do {
        int num;
        do {
          num = Random().nextInt(10);
        } while (num == 0);
        opt.add(num);
      } while (opt.length != 4);
    } else {
      opt.add(countAnswer! + Random().nextInt(6));
      opt.add(countAnswer! - Random().nextInt(4));
      do {
        opt.add(countAnswer! + Random().nextInt(10));
      } while (opt.length != 4);
    }
    Debug.printLog("options: $opt");

    options = opt.toList();
    options.shuffle();
    MyApp.flutterTts.stop();
    Utils.textToSpeech(Constant.txtCountTheObjects, MyApp.flutterTts);
    update([Constant.idCounting]);
  }

  answerColor() {
    if (options[0] == countAnswer) {
      return AppColor.violetSquare;
    } else if (options[1] == countAnswer) {
      return AppColor.redSquare;
    } else if (options[2] == countAnswer) {
      return AppColor.blueSquare;
    } else {
      return AppColor.lightBlueSquare;
    }
  }
}