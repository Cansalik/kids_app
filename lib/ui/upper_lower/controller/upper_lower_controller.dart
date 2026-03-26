import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/dialog/complete_dialog/complete_dialog_screen.dart';
import 'package:kids_playroom/main.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/debug.dart';
import 'package:kids_playroom/utils/utils.dart';

class UpperLowerController extends GetxController{
  PageController? pageController =
  PageController(viewportFraction: 1.0, keepPage: true);
  bool? accept = false;
  int? totalQue = 30;
  int? currentQue = 1;
  bool? isDrag = false;
  List<int> que = [];
  List<int> options = [];
  Set<int> count = {};
  dynamic args = Get.arguments;
  String? title;
  int? subId;


  @override
  void onInit() {
    getDataFromArgs();
    MyApp.flutterTts.stop();
    Utils.textToSpeech(title!, MyApp.flutterTts);
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
  Map<int, String> upper = {
    1: Constant.getAssetDrag()+"upper/A.webp",
    2: Constant.getAssetDrag()+"upper/B.webp",
    3: Constant.getAssetDrag()+"upper/C.webp",
    4: Constant.getAssetDrag()+"upper/D.webp",
    5: Constant.getAssetDrag()+"upper/E.webp",
    6: Constant.getAssetDrag()+"upper/F.webp",
    7: Constant.getAssetDrag()+"upper/G.webp",
    8: Constant.getAssetDrag()+"upper/H.webp",
    9: Constant.getAssetDrag()+"upper/I.webp",
    10: Constant.getAssetDrag()+"upper/J.webp",
    11: Constant.getAssetDrag()+"upper/K.webp",
    12: Constant.getAssetDrag()+"upper/L.webp",
    13: Constant.getAssetDrag()+"upper/M.webp",
    14: Constant.getAssetDrag()+"upper/N.webp",
    15: Constant.getAssetDrag()+"upper/O.webp",
    16: Constant.getAssetDrag()+"upper/P.webp",
    17: Constant.getAssetDrag()+"upper/Q.webp",
    18: Constant.getAssetDrag()+"upper/R.webp",
    19: Constant.getAssetDrag()+"upper/S.webp",
    20: Constant.getAssetDrag()+"upper/T.webp",
    21: Constant.getAssetDrag()+"upper/U.webp",
    22: Constant.getAssetDrag()+"upper/V.webp",
    23: Constant.getAssetDrag()+"upper/W.webp",
    24: Constant.getAssetDrag()+"upper/X.webp",
    25: Constant.getAssetDrag()+"upper/Y.webp",
    26: Constant.getAssetDrag()+"upper/Z.webp",
  };

  Map<int, String> lower = {
    1: Constant.getAssetDrag()+"lower/a.webp",
    2: Constant.getAssetDrag()+"lower/b.webp",
    3: Constant.getAssetDrag()+"lower/c.webp",
    4: Constant.getAssetDrag()+"lower/d.webp",
    5: Constant.getAssetDrag()+"lower/e.webp",
    6: Constant.getAssetDrag()+"lower/f.webp",
    7: Constant.getAssetDrag()+"lower/g.webp",
    8: Constant.getAssetDrag()+"lower/h.webp",
    9: Constant.getAssetDrag()+"lower/i.webp",
    10: Constant.getAssetDrag()+"lower/j.webp",
    11: Constant.getAssetDrag()+"lower/k.webp",
    12: Constant.getAssetDrag()+"lower/l.webp",
    13: Constant.getAssetDrag()+"lower/m.webp",
    14: Constant.getAssetDrag()+"lower/n.webp",
    15: Constant.getAssetDrag()+"lower/o.webp",
    16: Constant.getAssetDrag()+"lower/p.webp",
    17: Constant.getAssetDrag()+"lower/q.webp",
    18: Constant.getAssetDrag()+"lower/r.webp",
    19: Constant.getAssetDrag()+"lower/s.webp",
    20: Constant.getAssetDrag()+"lower/t.webp",
    21: Constant.getAssetDrag()+"lower/u.webp",
    22: Constant.getAssetDrag()+"lower/v.webp",
    23: Constant.getAssetDrag()+"lower/w.webp",
    24: Constant.getAssetDrag()+"lower/x.webp",
    25: Constant.getAssetDrag()+"lower/y.webp",
    26: Constant.getAssetDrag()+"lower/z.webp",
  };

  Map<int, String> alphabets = {
    1: "a",
    2: "b",
    3: "c",
    4: "d",
    5: "e",
    6: "f",
    7: "g",
    8: "h",
    9: "i",
    10: "j",
    11: "k",
    12: "l",
    13: "m",
    14: "n",
    15: "o",
    16: "p",
    17: "q",
    18: "r",
    19: "s",
    20: "t",
    21: "u",
    22: "v",
    23: "w",
    24: "x",
    25: "y",
    26: "z",
  };
  getOptions() {
    que = upper.keys.toList().sample(8);

    Set<int> opt = {};
    opt.addAll(que);
    do {
      var rnd = Random().nextInt(25);
      if (rnd != 0) {
        opt.add(rnd);
      }
    } while (opt.length != 15);

    options = opt.toList();
    options.shuffle();

    Debug.printLog("que: $que");
    Debug.printLog("opt: $options");
  }

  Future<void> onAccept(Object? data, int? pageIndex,
      BuildContext context) async {
    MyApp.flutterTts.stop();
    Utils.textToSpeech(
        alphabets[lower.keys.firstWhere((element) => lower[element] == data)]!,
        MyApp.flutterTts);
    if (count.length < que.length) {
        count.add(lower.keys.firstWhere((element) => lower[element] == data));
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
}