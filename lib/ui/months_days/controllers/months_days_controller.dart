import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kids_playroom/utils/color.dart';
import 'package:kids_playroom/utils/constant.dart';
import 'package:kids_playroom/utils/debug.dart';
import 'package:kids_playroom/utils/sizer_utils.dart';

class MonthsDaysController extends GetxController {
  PageController? pageController =
  PageController(viewportFraction: 1.0, keepPage: true);
  bool? accept = false;
  int? totalQue = 15;
  int? currentQue = 1;
  bool? isDrag = false;
  dynamic args = Get.arguments;
  String? title;
  int? subId;
  List<String> options = [];
  List<int> dragQue = [];
  Set<int> count = {};

  Map<int, String> mapMonth = {
    1: Constant.getAssetDragMonths()+"months_january.webp",
    2: Constant.getAssetDragMonths()+"months_february.webp",
    3: Constant.getAssetDragMonths()+"months_march.webp",
    4: Constant.getAssetDragMonths()+"months_april.webp",
    5: Constant.getAssetDragMonths()+"months_may.webp",
    6: Constant.getAssetDragMonths()+"months_june.webp",
    7: Constant.getAssetDragMonths()+"months_july.webp",
    8: Constant.getAssetDragMonths()+"months_august.webp",
    9: Constant.getAssetDragMonths()+"months_september.webp",
    10: Constant.getAssetDragMonths()+"months_october.webp",
    11: Constant.getAssetDragMonths()+"months_november.webp",
    12: Constant.getAssetDragMonths()+"months_december.webp",
  };
  Map<int, String> monthName = {
    1: "January",
    2: "February",
    3: "March",
    4: "April",
    5: "May",
    6: "June",
    7: "July",
    8: "August",
    9: "September",
    10: "October",
    11: "November",
    12: "December",
  };

  Map<int, String> map = {};
  Map<int, String> name = {};

  Map<int, String> mapDays = {
    1: Constant.getAssetDragDays()+"days_sunday.webp",
    2: Constant.getAssetDragDays()+"days_monday.webp",
    3: Constant.getAssetDragDays()+"days_tuesday.webp",
    4: Constant.getAssetDragDays()+"days_wednesday.webp",
    5: Constant.getAssetDragDays()+"days_thursday.webp",
    6: Constant.getAssetDragDays()+"days_friday.webp",
    7: Constant.getAssetDragDays()+"days_saturday.webp",
  };
  Map<int, String> dayName = {
    1: "Sunday",
    2: "Monday",
    3: "Tuesday",
    4: "Wednesday",
    5: "Thursday",
    6: "Friday",
    7: "Saturday",
  };


  @override
  void onInit() {
    getDataFromArgs();
    monthOption();
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

  monthOption() {
    int? num1;
    int? num2;
    if(title== "Months"){

        map.addAll(mapMonth);
        name.addAll(monthName);
        update();
    } else {
        map.addAll(mapDays);
        name.addAll(dayName);
        update();
    }
    var que = map.keys.toList();

    do {
      var numQue = Random().nextInt(que.length);
      dragQue = que.sample(numQue);
      Debug.printLog(dragQue.toString());
    } while (dragQue.length < 3);
    dragQue.sort((a, b) => a.compareTo(b));

    if (dragQue.length < 7) {
      num1 = Random().nextInt(dragQue.length);
      Debug.printLog("len: <7 $num1");
    } else {
      do {
        num1 = Random().nextInt(dragQue.length);
        num2 = Random().nextInt(dragQue.length);
        Debug.printLog("len: >7 $num1==$num2");
      } while (num1 == num2);
    }

    count.add(dragQue[num1]);
    if (num2 != null) {
      count.add(dragQue[num2]);
    }

    Debug.printLog("count: $count");

    options = map.values.toList();
    options.shuffle();
update();  }
  dragChild(int index) {
    if (count.contains(map.keys.firstWhere(
            (element) => map[element] == options[index]))) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          color: AppColor.transparent,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      );
    } else {
      return Container(
          height: AppSizes.height_6,
          width:AppSizes.width_28,
          margin: const EdgeInsets.symmetric(vertical: 12),
          decoration: const BoxDecoration(
            color: AppColor.transparent,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Image.asset(
            options[index],
            fit: BoxFit.fill,
          )
      );
    }
  }


}