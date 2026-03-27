import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/main.dart';
import 'package:kids_playroom/utils/color.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/debug.dart';
import 'package:kids_playroom/utils/utils.dart';

class TimeController extends GetxController {
  PageController? pageController =
  PageController(viewportFraction: 1.0, keepPage: true);
  int? currentQue = 1;
  int? totalQue = 15;

  bool? isDrag = false;
  dynamic args = Get.arguments;
  String? title;
  int? catId;

  @override
  void onInit() {
    getDataFromArgs();
    MyApp.flutterTts.stop();
    Utils.textToSpeech(title!, MyApp.flutterTts);
    generateTime();
    super.onInit();
  }
  getDataFromArgs() {
    if (args != null) {
      if (args[0] != null) {
        title = args[0];
      }
      if (args[1] != null) {
        catId = args[1];
      }
    }
  }
  Map<String, String> time = {
    "01:30": Constant.getAssetDragTime()+"time_1_30.webp",
    "04:15": Constant.getAssetDragTime()+"time_4_15.webp",
    "08:45": Constant.getAssetDragTime()+"time_8_45g.webp",
    "09:30": Constant.getAssetDragTime()+"time_9_30.webp",
    "02:30": Constant.getAssetDragTime()+"time_2_30.webp",
    "05:45": Constant.getAssetDragTime()+"time_5_45.webp",
    "10:00": Constant.getAssetDragTime()+"time_10.webp",
    "11:15": Constant.getAssetDragTime()+"time_11_15.webp",
    "03:00": Constant.getAssetDragTime()+"time_3.webp",
    "07:15": Constant.getAssetDragTime()+"time_7_15.webp",
    "12:00": Constant.getAssetDragTime()+"time_12.webp",
    "10:15": Constant.getAssetDragTime()+"time_10_15.webp",
    "02:45": Constant.getAssetDragTime()+"time_2_45g.webp",
    "06:00": Constant.getAssetDragTime()+"time_6.webp",
    "08:30": Constant.getAssetDragTime()+"time_8_30.webp",
    "11:45": Constant.getAssetDragTime()+"time_11_45.webp",
  };

  Map<String, String> timeText = {
  "01:30": "Bir buçuk",
  "04:15": "Dördü çeyrek geçiyor",
  "08:45": "Dokuza çeyrek var",
  "09:30": "Dokuz buçuk",
  "02:30": "İki buçuk",
  "05:45": "Altıya çeyrek var",
  "10:00": "Saat on",
  "11:15": "On biri çeyrek geçiyor",
  "03:00": "Saat üç",
  "07:15": "Yediyi çeyrek geçiyor",
  "12:00": "Saat on iki",
  "10:15": "Onu çeyrek geçiyor",
  "02:45": "Üçe çeyrek var",
  "06:00": "Saat altı",
  "08:30": "Sekiz buçuk",
  "11:45": "On ikiye çeyrek var"
  };

  List<String> option = [];
  List<String> que = [];
  Set<String> count = {};
  String? current;

  bool? accept = false;
  optionColor(int index) {
    if (index == 0) {
      return AppColor.yellowGradient;
    } else if (index == 1) {
      return AppColor.greenGradient;
    } else if (index == 2) {
      return AppColor.redGradient;
    } else {
      return AppColor.violetGradient;
    }
  }

  generateTime() {
    option = time.keys.toList().sample(4);
    Debug.printLog(option.toString());
    for (var element in option) {
      Debug.printLog(element);
      que.add(time[element]!);
    }
    que.shuffle();
  }

}