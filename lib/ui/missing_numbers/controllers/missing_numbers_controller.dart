import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/dialog/complete_dialog/complete_dialog_screen.dart';
import 'package:kids_playroom/main.dart';
import 'package:kids_playroom/utils/debug.dart';
import 'package:kids_playroom/utils/utils.dart';

class MissingNumbersController extends GetxController {
  PageController? pageController =
  PageController(viewportFraction: 1.0, keepPage: true);
  bool? accept = false;
  int? totalQue = 30;
  int? currentQue = 1;
  bool? isDrag = false;
  Set<int> que = {};
  List<int> options = [];
  Set<int> count = {};
  dynamic args = Get.arguments;
  String? title;
  int? subId;


  @override
  void onInit() {
    getDataFromArgs();
    getOptions();
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


  Future<void> onAccept(Object? data, int? pageIndex, BuildContext context) async {
    if (count.length < que.length) {
        count.add(int.parse(data.toString()));
        update();
    }

    if (count.length == que.length) {
      MyApp.flutterTts.stop();
      Utils.textToSpeech("Awesome", MyApp.flutterTts);
        accept = true;
        update();
      await Future.delayed(const Duration(milliseconds: 2280), () {
        if (pageIndex != totalQue! - 1) {
          pageController!.jumpToPage(pageIndex! + 1);
            accept = false;
            currentQue = currentQue! + 1;
            update();
          count.clear();
          options.clear();
          que.clear();
          getOptions();
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return CompleteDialog(restartFunction: () {
                  Navigator.of(context).pop();
                    accept = false;
                    currentQue = 1;
                    update();
                  pageController!.jumpToPage(0);
                  count.clear();
                  options.clear();
                  que.clear();
                  getOptions();
                });
              });
        }
      });
    }
  }

  getOptions() {
    List<int> list = List.generate(30, (index) => index + 1);
    int n1, n2;
    do {
      do {
        n1 = Random().nextInt(30);
        do {
          n2 = Random().nextInt(30);
        } while (n1>n2);
      } while (n2-n1 < 5);
    } while (n2-n1 > 18);
    Debug.printLog("n1: $n1 -- n2: $n2");
    que.addAll(list.getRange(n1, n2));
    Debug.printLog("que: $que");
    Set<int> opt = {};
    opt.addAll(que);
    do {
      opt.add(Random().nextInt(30));
    } while (opt.length != 20);
    Debug.printLog("opt: $opt");
    options = opt.toList();
    options.shuffle();

    if (que.length < 7) {
      count.add(que.toList()[Random().nextInt(que.length)]);
    } else if (que.length > 5 && que.length < 13) {
      count.add(que.toList()[Random().nextInt(que.length)]);
      count.add(que.toList()[Random().nextInt(que.length)]);
    } else {
      count.add(que.toList()[Random().nextInt(que.length)]);
      count.add(que.toList()[Random().nextInt(que.length)]);
      count.add(que.toList()[Random().nextInt(que.length)]);
    }
    Debug.printLog("count: $count");
  }




}